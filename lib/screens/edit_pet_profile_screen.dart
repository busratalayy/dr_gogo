import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_controller.dart';
import '../models/pet_model.dart';

class EditPetProfileScreen extends StatefulWidget {
  final PetModel pet;

  const EditPetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  State<EditPetProfileScreen> createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = ProfileController();

  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController weightController;

  late String selectedType;
  late String selectedGender;

  bool isLoading = false;

  String selectedImagePath = '';
  final ImagePicker _picker = ImagePicker();

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.pet.name);
    breedController = TextEditingController(text: widget.pet.breed);
    ageController = TextEditingController(text: widget.pet.age.toString());
    weightController =
        TextEditingController(text: widget.pet.weight.toString());

    selectedType = widget.pet.type;
    selectedGender = widget.pet.gender;
    selectedImagePath = widget.pet.imagePath;
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> updatePetProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final result = await _profileController.updatePetProfile(
      petId: widget.pet.petId,
      name: nameController.text,
      type: selectedType,
      breed: breedController.text,
      age: ageController.text,
      weight: weightController.text,
      gender: selectedGender,
      imagePath: selectedImagePath,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pet profile updated successfully!"),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Edit Pet Profile",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 118,
                        height: 118,
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
                        child: selectedImagePath.isNotEmpty
                            ? ClipOval(
                          child: Image.file(
                            File(selectedImagePath),
                            width: 118,
                            height: 118,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.pets,
                          size: 50,
                          color: accentColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: pickImageFromGallery,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Update Pet Information",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Edit your pet’s saved information and keep the profile up to date.",
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildTextField(
                        controller: nameController,
                        label: "Pet Name",
                        icon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter pet name";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      buildDropdown(
                        label: "Species",
                        icon: Icons.pets,
                        value: selectedType,
                        items: const ["Dog", "Cat"],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      buildTextField(
                        controller: breedController,
                        label: "Breed",
                        icon: Icons.category_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter breed";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      buildDropdown(
                        label: "Gender",
                        icon: Icons.wc,
                        value: selectedGender,
                        items: const ["Male", "Female"],
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              controller: ageController,
                              label: "Age",
                              icon: Icons.cake_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: buildTextField(
                              controller: weightController,
                              label: "Weight (kg)",
                              icon: Icons.monitor_weight_outlined,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : updatePetProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accentColor),
        labelText: label,
        labelStyle: const TextStyle(color: subtitleColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accentColor),
        labelText: label,
        labelStyle: const TextStyle(color: subtitleColor),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ),
      )
          .toList(),
    );
  }
}