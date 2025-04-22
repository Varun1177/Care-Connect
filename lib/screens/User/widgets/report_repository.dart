import 'package:cloud_firestore/cloud_firestore.dart';
import 'report.dart';

class ReportRepository {
  final CollectionReference _reportsCollection = 
      FirebaseFirestore.instance.collection('reports');

  // Add a new report to the database
  Future<String> addReport(Report report) async {
    try {
      DocumentReference docRef = await _reportsCollection.add(report.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add report: $e');
    }
  }

  // Get all reports
  Stream<List<Report>> getReports() {
    return _reportsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Report.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get reports by NGO ID
  Stream<List<Report>> getReportsByNgoId(String ngoId) {
    return _reportsCollection
        .where('ngoId', isEqualTo: ngoId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Report.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}