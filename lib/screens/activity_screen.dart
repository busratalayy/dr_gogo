import 'package:flutter/material.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

  final DatabaseReference activityRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://dr-gogo-a2975-default-rtdb.europe-west1.firebasedatabase.app",
  ).ref("activity");

  String status = "Waiting...";
  String movementLevel = "No Data";
  String motionDetection = "No Motion";
  String lastActivity = "No data";
  int activityScore = 0;

  double accelX = 0.0;
  double accelY = 0.0;
  double accelZ = 0.0;

  double gyroX = 0.0;
  double gyroY = 0.0;
  double gyroZ = 0.0;

  @override
  void initState() {
    super.initState();
    listenActivityData();
  }

  void listenActivityData() {
    activityRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) return;

      try {
        final map = Map<dynamic, dynamic>.from(data as Map);

        final x = double.tryParse(map["accelX"].toString()) ?? 0.0;
        final y = double.tryParse(map["accelY"].toString()) ?? 0.0;
        final z = double.tryParse(map["accelZ"].toString()) ?? 0.0;

        final gx = double.tryParse(map["gyroX"].toString()) ?? 0.0;
        final gy = double.tryParse(map["gyroY"].toString()) ?? 0.0;
        final gz = double.tryParse(map["gyroZ"].toString()) ?? 0.0;

        final level = map["movementLevel"]?.toString() ?? "No Data";
        final currentStatus = map["status"]?.toString() ?? "Waiting...";

        final movementScore =
        (x.abs() + y.abs() + (z - 9.8).abs()).clamp(0, 10);

        setState(() {
          accelX = x;
          accelY = y;
          accelZ = z;

          gyroX = gx;
          gyroY = gy;
          gyroZ = gz;

          status = currentStatus;
          movementLevel = level;
          activityScore = (movementScore * 10).round().clamp(0, 100);
          motionDetection =
          currentStatus == "Resting" ? "No Motion" : "Detected";
          lastActivity =
          currentStatus == "Resting" ? "No recent activity" : "Just Now";
        });
      } catch (e) {
        print("Activity parse error: $e");
      }
    });
  }

  String getDailySummaryText() {
    if (status == "Resting") {
      return "Your pet is currently resting and no significant movement has been detected.";
    } else if (status == "Walking") {
      return "Your pet is currently walking and showing a moderate level of activity.";
    } else if (status == "Active Movement") {
      return "Your pet is highly active. Strong movement has been detected.";
    } else {
      return "Waiting for live activity data from the wearable sensor.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Activity",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Activity 🐾",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Monitor your pet’s movement using live MPU6050 sensor data.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),

            buildMainStatusCard(),

            const SizedBox(height: 22),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                buildInfoCard(
                  title: "Movement Level",
                  value: movementLevel,
                  icon: Icons.show_chart,
                  iconColor: Colors.blue,
                ),
                buildInfoCard(
                  title: "Activity Score",
                  value: "$activityScore%",
                  icon: Icons.bolt,
                  iconColor: Colors.orange,
                ),
                buildInfoCard(
                  title: "Motion Detection",
                  value: motionDetection,
                  icon: Icons.directions_run,
                  iconColor: Colors.green,
                ),
                buildInfoCard(
                  title: "Last Activity",
                  value: lastActivity,
                  icon: Icons.access_time,
                  iconColor: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 28),

            buildDailySummaryCard(),

            const SizedBox(height: 20),

            buildSensorDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget buildMainStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade300,
            Colors.teal.shade500,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.dog,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 14),
          const Text(
            "Current Status",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDailySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: buildCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.insights,
              color: Colors.teal,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Summary",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  getDailySummaryText(),
                  style: const TextStyle(
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSensorDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.memory,
                color: Colors.teal,
              ),
              SizedBox(width: 8),
              Text(
                "Sensor Details",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Accel X : ${accelX.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
          Text(
            "Accel Y : ${accelY.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
          Text(
            "Accel Z : ${accelZ.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
          const SizedBox(height: 12),
          Text(
            "Gyro X : ${gyroX.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
          Text(
            "Gyro Y : ${gyroY.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
          Text(
            "Gyro Z : ${gyroZ.toStringAsFixed(2)}",
            style: const TextStyle(color: subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: buildCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor.withOpacity(0.12),
            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
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
            ),
          ),
        ],
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