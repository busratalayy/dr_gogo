import '../services/profile_service.dart';
import '../models/pet_model.dart';

class ProfileController {
  final ProfileService _profileService = ProfileService();

  Future<String?> savePetProfile({
    required String name,
    required String type,
    required String breed,
    required String age,
    required String weight,
    required String gender,
  }) async {
    if (name.trim().isEmpty) {
      return "Pet name cannot be empty.";
    }

    if (breed.trim().isEmpty) {
      return "Breed cannot be empty.";
    }

    final int? parsedAge = int.tryParse(age.trim());
    if (parsedAge == null || parsedAge <= 0) {
      return "Please enter a valid age.";
    }

    final double? parsedWeight = double.tryParse(weight.trim());
    if (parsedWeight == null || parsedWeight <= 0) {
      return "Please enter a valid weight.";
    }

    try {
      await _profileService.savePetProfile(
        name: name,
        type: type,
        breed: breed,
        age: parsedAge,
        weight: parsedWeight,
        gender: gender,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> isProfileCompleted() async {
    return await _profileService.isProfileCompleted();
  }
  Future<PetModel?> getCurrentPet() async {
    return await _profileService.getCurrentPet();
  }
  Future<String?> updatePetProfile({
    required String petId,
    required String name,
    required String type,
    required String breed,
    required String age,
    required String weight,
    required String gender,
    String imagePath = '',
  }) async {
    if (name.trim().isEmpty) {
      return "Pet name cannot be empty.";
    }

    if (breed.trim().isEmpty) {
      return "Breed cannot be empty.";
    }

    final int? parsedAge = int.tryParse(age.trim());
    if (parsedAge == null || parsedAge <= 0) {
      return "Please enter a valid age.";
    }

    final double? parsedWeight = double.tryParse(weight.trim());
    if (parsedWeight == null || parsedWeight <= 0) {
      return "Please enter a valid weight.";
    }

    try {
      await _profileService.updatePetProfile(
        petId: petId,
        name: name,
        type: type,
        breed: breed,
        age: parsedAge,
        weight: parsedWeight,
        gender: gender,
        imagePath: imagePath,
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}