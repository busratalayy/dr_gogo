class OwnerModel {
  final String ownerId;
  final String fullName;
  final String email;
  final bool profileCompleted;
  final DateTime createdAt;

  OwnerModel({
    required this.ownerId,
    required this.fullName,
    required this.email,
    required this.profileCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'fullName': fullName,
      'email': email,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OwnerModel.fromMap(Map<String, dynamic> map) {
    return OwnerModel(
      ownerId: map['ownerId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profileCompleted: map['profileCompleted'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}