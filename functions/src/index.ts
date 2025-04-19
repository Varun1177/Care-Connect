import * as admin from "firebase-admin";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {getDistance} from "geolib";

admin.initializeApp();
const db = admin.firestore();

const DONATION_THRESHOLD = 200;
const RADIUS_IN_KM = 3;

type DonationData = {
  latitude: number;
  longitude: number;
  quantity: number;
  type: string;
};

type NGOData = {
  ngoId: string;
  latitude: number;
  longitude: number;
  acceptedDonations: string[];
};

export const checkNearbyDonations = onDocumentCreated(
  "donation_requests/{donationId}",
  async (event) => {
    const snap = event.data;

    if (!snap) {
      console.log("No data found in event.");
      return;
    }

    const newDonation = snap.data() as DonationData;
    const {latitude, longitude, quantity, type} = newDonation;

    console.log("Received donation data:", {
      latitude,
      longitude,
      quantity,
      type,
    });


    if (
      typeof latitude !== "number" ||
      typeof longitude !== "number" ||
      typeof quantity !== "number" ||
      !type
    ) {
      console.log("Incomplete or invalid donation data");
      return;
    }

    const center = {latitude, longitude};

    try {
      const donationsSnap = await db.collection("donation_requests").get();
      let totalQuantity = 0;

      donationsSnap.docs.forEach((doc) => {
        const donation = doc.data() as DonationData;

        if (
          typeof donation.latitude !== "number" ||
          typeof donation.longitude !== "number" ||
          typeof donation.quantity !== "number"
        ) {
          console.warn(`Skipping invalid donation: ${doc.id}`);
          return;
        }

        const distanceInMeters = getDistance(
          {latitude: donation.latitude, longitude: donation.longitude},
          center
        );

        const distanceInKm = distanceInMeters / 1000;

        if (distanceInKm <= RADIUS_IN_KM && donation.type === type) {
          totalQuantity += donation.quantity;
        }
      });

      if (totalQuantity >= DONATION_THRESHOLD) {
        console.log(`Threshold reached: ${totalQuantity} units of ${type}.`);

        const ngoSnap = await db
          .collection("ngos")
          .where("approved", "==", true)
          .where("acceptedDonations", "array-contains", type)
          .get();

        const nearbyNGOs: NGOData[] = [];

        ngoSnap.docs.forEach((doc) => {
          const ngo = doc.data() as NGOData;

          if (
            typeof ngo.latitude !== "number" ||
            typeof ngo.longitude !== "number"
          ) {
            console.warn(`Skipping invalid NGO location: ${doc.id}`);
            return;
          }

          const distanceToNGO = getDistance(
            {latitude: ngo.latitude, longitude: ngo.longitude},
            center
          );
          const distanceToNGOKm = distanceToNGO / 1000;

          if (distanceToNGOKm <= RADIUS_IN_KM) {
            nearbyNGOs.push(ngo);
          }
        });

        if (nearbyNGOs.length > 0) {
          const batch = db.batch();

          nearbyNGOs.forEach((ngo) => {
            const alertRef = db.collection("notifications").doc();

            batch.set(alertRef, {
              ngoId: ngo.ngoId,
              message: `${type} donations in the area! organize a drive.`,
              location: center,
              timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });
          });

          await batch.commit();
          console.log(`Notified ${nearbyNGOs.length} NGOs.`);
        } else {
          console.log("No nearby NGOs found to notify.");
        }
      } else {
        console.log(`Quantity ${totalQuantity} is below the threshold.`);
      }
    } catch (error) {
      console.error("Error in checkNearbyDonations function:", error);
    }

    return;
  }
);
