import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/pet_model.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePetProfile({
    required String name,
    required String type,
    required String breed,
    required int age,
    required double weight,
    required String gender,
    String imagePath = '',
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged in user found.");
    }

    final String ownerId = user.uid;
    final String petId = _firestore.collection('pets').doc().id;

    final pet = PetModel(
      petId: petId,
      ownerId: ownerId,
      name: name.trim(),
      type: type,
      breed: breed.trim(),
      age: age,
      weight: weight,
      gender: gender,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('pets').doc(petId).set(pet.toMap());

    await _firestore.collection('owners').doc(ownerId).update({
      'profileCompleted': true,
    });
  }

  Future<bool> isProfileCompleted() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final doc = await _firestore.collection('owners').doc(user.uid).get();

    if (!doc.exists) {
      return false;
    }

    return doc.data()?['profileCompleted'] == true;
  }
  Future<PetModel?> getCurrentPet() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final query = await _firestore
        .collection('pets')
        .where('ownerId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return PetModel.fromMap(query.docs.first.data());
  }
  Future<void> updatePetProfile({
    required String petId,
    required String name,
    required String type,
    required String breed,
    required int age,
    required double weight,
    required String gender,
    String imagePath = '',
  }) async {
    await _firestore.collection('pets').doc(petId).update({
      'name': name.trim(),
      'type': type,
      'breed': breed.trim(),
      'age': age,
      'weight': weight,
      'gender': gender,
      'imagePath': imagePath,
    });
  }
}