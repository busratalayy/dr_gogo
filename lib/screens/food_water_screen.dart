import 'package:flutter/material.dart';
import '../services/food_water_service.dart';

class FoodWaterScreen extends StatefulWidget {
  const FoodWaterScreen({super.key});

  @override
  State<FoodWaterScreen> createState() => _FoodWaterScreenState();
}

class _FoodWaterScreenState extends State<FoodWaterScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();

  double petWeight = 20.0; // Şimdilik fake pet weight
  String selectedActivity = "Normal";

  double dailyCalories = 0;
  double foodAmount = 0;
  double waterNeed = 0;

  bool isCalculated = false;

  double getActivityFactor() {
    if (selectedActivity == "Low") return 1.2;
    if (selectedActivity == "Normal") return 1.6;
    return 2.0;
  }

  void calculatePlan() {
    double kcalPerGram = double.tryParse(kcalController.text) ?? 0;

    if (kcalPerGram <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid kcal/g value."),
        ),
      );
      return;
    }

    dailyCalories = FoodWaterService.calculateDailyCalories(
      weight: petWeight,
      activityFactor: getActivityFactor(),
    );

    foodAmount = FoodWaterService.calculateFoodAmount(
      dailyCalories: dailyCalories,
      kcalPerGram: kcalPerGram,
    );

    waterNeed = FoodWaterService.calculateWaterNeed(petWeight);

    setState(() {
      isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          "Food & Water",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Nutrition Plan 🍖",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Estimate your pet’s daily food and water needs.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 26),

            buildPetInfoCard(),

            const SizedBox(height: 22),

            buildInputCard(),

            const SizedBox(height: 24),

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
                onPressed: calculatePlan,
                child: const Text(
                  "Calculate Plan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26),

            if (isCalculated) buildResultSection(),

            const SizedBox(height: 18),

            buildNoteCard(),
          ],
        ),
      ),
    );
  }

  Widget buildPetInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: buildCardDecoration(),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.pets,
              color: accentColor,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pet Information",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Weight: ${petWeight.toStringAsFixed(1)} kg",
                  style: const TextStyle(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: buildCardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Food Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 18),

          buildTextField(
            controller: foodNameController,
            label: "Food Brand / Name",
            icon: Icons.restaurant,
          ),

          const SizedBox(height: 16),

          buildTextField(
            controller: kcalController,
            label: "Calories per gram",
            icon: Icons.local_fire_department,
            keyboardType: TextInputType.number,
            suffix: "kcal/g",
          ),

          const SizedBox(height: 18),

          const Text(
            "Activity Level",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              buildActivityButton("Low"),
              const SizedBox(width: 10),
              buildActivityButton("Normal"),
              const SizedBox(width: 10),
              buildActivityButton("High"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActivityButton(String title) {
    final bool selected = selectedActivity == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedActivity = title;
          });
        },

        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? accentColor : const Color(0xFFF1F1EF),
            borderRadius: BorderRadius.circular(16),
          ),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResultSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildResultCard(
                title: "Daily Calories",
                value: "${dailyCalories.toStringAsFixed(0)} kcal",
                icon: Icons.bolt,
                color: Colors.orange,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: buildResultCard(
                title: "Food Amount",
                value: "${foodAmount.toStringAsFixed(0)} g",
                icon: Icons.lunch_dining,
                color: Colors.brown,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        buildWideResultCard(
          title: "Recommended Water Intake",
          value: "${waterNeed.toStringAsFixed(0)} ml / day",
          icon: Icons.water_drop,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget buildResultCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: buildCardDecoration(),

      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.13),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: subtitleColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWideResultCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: buildCardDecoration(),

      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.13),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  title,
                  style: const TextStyle(
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(22),
      ),

      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              "This is an estimated care suggestion. Please consult a veterinarian for a personalized diet plan.",
              style: TextStyle(
                color: Color(0xFF6E6E6E),
                height: 1.4,
              ),
            ),
          ),
        ],
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
        prefixIcon: Icon(
          icon,
          color: accentColor,
        ),

        suffixText: suffix,

        suffixStyle: const TextStyle(
          color: subtitleColor,
        ),

        labelText: label,

        labelStyle: const TextStyle(
          color: subtitleColor,
        ),

        filled: true,

        fillColor: const Color(0xFFF4F4F2),

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

  BoxDecoration buildCardDecoration() {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(24),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}