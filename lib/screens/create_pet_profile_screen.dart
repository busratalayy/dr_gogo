import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import 'dashboard_screen.dart';

class CreatePetProfileScreen extends StatefulWidget {
  const CreatePetProfileScreen({super.key});

  @override
  State<CreatePetProfileScreen> createState() => _CreatePetProfileScreenState();
}

class _CreatePetProfileScreenState extends State<CreatePetProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = ProfileController();
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedSpecies = "Dog";
  String selectedGender = "Male";

  bool isLoading = false;

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color mainColor = Color(0xFF4DB6AC);

  @override
  void dispose() {
    petNameController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> savePetProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final result = await _profileController.savePetProfile(
      name: petNameController.text,
      type: selectedSpecies,
      breed: breedController.text,
      age: ageController.text,
      weight: weightController.text,
      gender: selectedGender,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pet profile saved successfully!"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 50,
                      color: mainColor,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Create Pet Profile",
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Add your pet’s basic information to personalize health monitoring.",
                  style: TextStyle(
                    fontSize: 15,
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
                        controller: petNameController,
                        label: "Pet Name",
                        icon: Icons.badge_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your pet's name";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      buildDropdown(
                        label: "Species",
                        icon: Icons.pets,
                        value: selectedSpecies,
                        items: const ["Dog", "Cat"],
                        onChanged: (value) {
                          setState(() {
                            selectedSpecies = value!;
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
                          onPressed: isLoading ? null : savePetProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
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
                            "Save Pet Profile",
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
        prefixIcon: Icon(icon, color: mainColor),
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
        prefixIcon: Icon(icon, color: mainColor),
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