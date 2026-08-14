import 'package:car_care_plus/features/packages/data/models/package_model.dart';

class UserPackageModel {
  final int id;
  final int userId;
  final int packageId;
  final String? startDate;
  final String? endDate;
  final int remainingCount;
  final String status;
  final PackageModel? packageDetails;

  UserPackageModel({
    required this.id,
    required this.userId,
    required this.packageId,
    this.startDate,
    this.endDate,
    required this.remainingCount,
    required this.status,
    this.packageDetails,
  });

  factory UserPackageModel.fromJson(Map<String, dynamic> json) {
    return UserPackageModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      startDate: json['start_date'],
      endDate: json['end_date'],
      remainingCount: json['remaining_count'] ?? 0,
      status: json['status'] ?? 'inactive',
      packageDetails: json['package'] != null
          ? PackageModel.fromJson(json['package'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_id': packageId,
      'start_date': startDate,
      'end_date': endDate,
      'remaining_count': remainingCount,
      'status': status,
      if (packageDetails != null) 'package': packageDetails!.toJson(),
    };
  }
}