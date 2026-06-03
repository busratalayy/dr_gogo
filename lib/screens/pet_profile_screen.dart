import 'package:flutter/material.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedType = "Cat";
  String selectedGender = "Female";

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
      bottomNavigationBar:
      const BottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Tell us about your pet 🐾",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "This information helps Dr. Gogo personalize health and care suggestions.",
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
                    child: const Icon(
                      Icons.pets,
                      size: 48,
                      color: accentColor,
                    ),
                  ),

                  Container(
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
                ],
              ),
            ),

            const SizedBox(height: 30),

            buildTextField(
              controller: nameController,
              label: "Pet Name",
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 16),

            buildTextField(
              controller: breedController,
              label: "Breed",
              icon: Icons.category_outlined,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    controller: ageController,
                    label: "Age",
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: buildTextField(
                    controller: weightController,
                    label: "Weight",
                    icon: Icons.monitor_weight_outlined,
                    keyboardType: TextInputType.number,
                    suffix: "kg",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            buildSectionTitle("Pet Type"),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: buildSelectionButton(
                    title: "Cat",
                    icon: Icons.pets,
                    selected: selectedType == "Cat",
                    onTap: () {
                      setState(() {
                        selectedType = "Cat";
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: buildSelectionButton(
                    title: "Dog",
                    icon: Icons.cruelty_free,
                    selected: selectedType == "Dog",
                    onTap: () {
                      setState(() {
                        selectedType = "Dog";
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            buildSectionTitle("Gender"),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: buildSelectionButton(
                    title: "Female",
                    icon: Icons.female,
                    selected: selectedGender == "Female",
                    onTap: () {
                      setState(() {
                        selectedGender = "Female";
                      });
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: buildSelectionButton(
                    title: "Male",
                    icon: Icons.male,
                    selected: selectedGender == "Male",
                    onTap: () {
                      setState(() {
                        selectedGender = "Male";
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 34),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save Profile",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accentColor),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: subtitleColor),
        labelText: label,
        labelStyle: const TextStyle(color: subtitleColor),
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildSelectionButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: selected ? accentColor : cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : accentColor,
              size: 22,
            ),

            const SizedBox(width: 8),

            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}