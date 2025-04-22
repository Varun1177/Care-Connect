import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String? id;
  final String ngoId;
  final String ngoName;
  final String reason;
  final String description;
  final List<String> evidenceUrls;
  final DateTime createdAt;
  final String user;

  Report({
    this.id,
    required this.ngoId,
    required this.ngoName,
    required this.reason,
    required this.description,
    required this.evidenceUrls,
    required this.createdAt,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'ngoId': ngoId,
      'ngoName': ngoName,
      'reason': reason,
      'description': description,
      'evidenceUrls': evidenceUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'user': user,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map, String id) {
    return Report(
      id: id,
      ngoId: map['ngoId'] ?? '',
      ngoName: map['ngoName'] ?? '',
      reason: map['reason'] ?? '',
      description: map['description'] ?? '',
      evidenceUrls: List<String>.from(map['evidenceUrls'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      user: map['user'] ?? '',
    );
  }
}