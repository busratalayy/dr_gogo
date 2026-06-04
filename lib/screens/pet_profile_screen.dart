import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

import '../controllers/profile_controller.dart';
import '../models/pet_model.dart';
import 'create_pet_profile_screen.dart';
import 'edit_pet_profile_screen.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  final ProfileController _profileController = ProfileController();

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  late Future<PetModel?> _petFuture;

  @override
  void initState() {
    super.initState();
    _petFuture = _profileController.getCurrentPet();
  }

  void refreshPetProfile() {
    setState(() {
      _petFuture = _profileController.getCurrentPet();
    });
  }

  void goToEditProfile(PetModel pet) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPetProfileScreen(pet: pet),
      ),
    );

    refreshPetProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Pet Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: FutureBuilder<PetModel?>(
        future: _petFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: accentColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "An error occurred while loading pet profile.",
                style: TextStyle(color: textColor),
              ),
            );
          }

          final pet = snapshot.data;

          if (pet == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pets,
                      size: 72,
                      color: accentColor,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "No Pet Profile Found",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Create a pet profile to start monitoring your pet.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreatePetProfileScreen(),
                          ),
                        ).then((_) => refreshPetProfile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create Pet Profile"),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Pet Profile 🐾",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "View your pet’s saved information.",
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 26),

                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: pet.imagePath.isNotEmpty
                            ? ClipOval(
                          child: Image.file(
                            File(pet.imagePath),
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.pets,
                          size: 54,
                          color: accentColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => goToEditProfile(pet),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                Center(
                  child: Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Center(
                  child: Text(
                    "${pet.type} • ${pet.breed}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: subtitleColor,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                buildInfoCard(
                  icon: Icons.pets,
                  title: "Pet Type",
                  value: pet.type,
                ),
                buildInfoCard(
                  icon: Icons.category_outlined,
                  title: "Breed",
                  value: pet.breed,
                ),
                buildInfoCard(
                  icon: pet.gender == "Female" ? Icons.female : Icons.male,
                  title: "Gender",
                  value: pet.gender,
                ),
                buildInfoCard(
                  icon: Icons.cake_outlined,
                  title: "Age",
                  value: "${pet.age} years old",
                ),
                buildInfoCard(
                  icon: Icons.monitor_weight_outlined,
                  title: "Weight",
                  value: "${pet.weight} kg",
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => goToEditProfile(pet),
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Edit Pet Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}