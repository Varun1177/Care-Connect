import 'package:cloud_firestore/cloud_firestore.dart';

class NGOService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getApprovedNGO(String email) {
    return _firestore.collection('ngos').where('email', isEqualTo: email).snapshots();
  }

  Stream<QuerySnapshot> getPendingNGO(String email) {
    return _firestore.collection('pending_approvals').where('email', isEqualTo: email).snapshots();
  }
}
