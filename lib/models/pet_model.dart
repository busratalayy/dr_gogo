class PetModel {
  final String petId;
  final String ownerId;

  final String name;
  final String type;
  final String breed;
  final int age;
  final double weight;
  final String gender;
  final String imagePath;

  final DateTime createdAt;

  PetModel({
    required this.petId,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.weight,
    required this.gender,
    required this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'weight': weight,
      'gender': gender,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      petId: map['petId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      gender: map['gender'] ?? '',
      imagePath: map['imagePath'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}