import 'dart:math';

class FoodWaterService {

  // RER (Resting Energy Requirement)
  // Temel günlük enerji ihtiyacı
  static double calculateRER(double weight) {

    return 70 * pow(weight, 0.75).toDouble();
  }


  // Günlük kalori ihtiyacı
  static double calculateDailyCalories({
    required double weight,
    required double activityFactor,
  }) {

    return calculateRER(weight) * activityFactor;
  }


  // Günlük mama miktarı (gram)
  static double calculateFoodAmount({
    required double dailyCalories,
    required double kcalPerGram,
  }) {

    return dailyCalories / kcalPerGram;
  }


  // Günlük su ihtiyacı (ml)
  static double calculateWaterNeed(double weight) {

    return weight * 50;
  }
}