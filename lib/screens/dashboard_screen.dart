import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dr_gogo/screens/pet_profile_screen.dart';
import 'package:dr_gogo/screens/activity_screen.dart';
import 'package:dr_gogo/screens/food_water_screen.dart';
import 'package:dr_gogo/screens/location_screen.dart';
import 'package:dr_gogo/screens/health_vaccine_screen.dart';
import 'package:dr_gogo/screens/alert_screen.dart';
import 'package:dr_gogo/screens/login_screen.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';
import 'package:dr_gogo/screens/change_password_screen.dart';

import '../controllers/profile_controller.dart';
import '../models/pet_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileController _profileController = ProfileController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final DatabaseReference sensorRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://dr-gogo-a2975-default-rtdb.europe-west1.firebasedatabase.app/",
  ).ref("iot/sensorData");

  late Future<PetModel?> _petFuture;

  static const Color backgroundColor = DashboardScreen.backgroundColor;
  static const Color cardColor = DashboardScreen.cardColor;
  static const Color textColor = DashboardScreen.textColor;
  static const Color subtitleColor = DashboardScreen.subtitleColor;

  String get ownerId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _petFuture = _profileController.getCurrentPet();
  }

  int daysLeft(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.difference(todayOnly).inDays;
  }

  void refreshDashboard() {
    setState(() {
      _petFuture = _profileController.getCurrentPet();
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  Future<void> sendPasswordResetEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No email address found for this account."),
        ),
      );
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Password reset email sent to $email"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem("Pet Profile", Icons.pets, Colors.purple),
      DashboardItem("Activity", Icons.pets, Colors.blue),
      DashboardItem("Food & Water", Icons.restaurant, Colors.orange),
      DashboardItem("Location", Icons.location_on, Colors.green),
      DashboardItem("Alerts", Icons.notifications_active, Colors.amber),
      DashboardItem("Health & Vaccine", Icons.health_and_safety, Colors.red),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: buildDrawer(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textColor,
        title: const Text(
          "Dr. Gogo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      bottomNavigationBar: buildDashboardBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPetHeader(),
            const SizedBox(height: 20),
            buildPulseCard(),
            const SizedBox(height: 22),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  color: cardColor,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () async {
                      if (item.title == "Pet Profile") {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PetProfileScreen(),
                          ),
                        );
                        refreshDashboard();
                      } else if (item.title == "Activity") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivityScreen(),
                          ),
                        );
                      } else if (item.title == "Food & Water") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FoodWaterScreen(),
                          ),
                        );
                      } else if (item.title == "Location") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationScreen(),
                          ),
                        );
                      } else if (item.title == "Alerts") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlertsScreen(),
                          ),
                        );
                      } else if (item.title == "Health & Vaccine") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const HealthVaccineScreen(),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 31,
                            backgroundColor: item.color.withOpacity(0.14),
                            child: Icon(
                              item.icon,
                              color: item.color,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDashboardBottomNavBar() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore
          .collection("reminders")
          .where("ownerId", isEqualTo: ownerId)
          .snapshots(),
      builder: (context, reminderSnapshot) {
        final reminders = reminderSnapshot.data?.docs ?? [];

        final unreadReminderCount = reminders.where((doc) {
          final data = doc.data();
          return data["isRead"] == false;
        }).length;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestore
              .collection("vaccines")
              .where("ownerId", isEqualTo: ownerId)
              .snapshots(),
          builder: (context, vaccineSnapshot) {
            final vaccines = vaccineSnapshot.data?.docs ?? [];

            final upcomingVaccinesCount = vaccines.where((doc) {
              final data = doc.data();
              final next = data["next"];

              if (next == null) return false;

              final date = (next as Timestamp).toDate();
              final days = daysLeft(date);

              return days >= 0 && days <= 7;
            }).length;

            final notificationCount =
                unreadReminderCount + upcomingVaccinesCount;

            return BottomNavBar(
              currentIndex: 0,
              notificationCount: notificationCount,
            );
          },
        );
      },
    );
  }

  Widget buildDrawer() {
    final String email = FirebaseAuth.instance.currentUser?.email ?? "";

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: FutureBuilder<PetModel?>(
          future: _petFuture,
          builder: (context, snapshot) {
            final pet = snapshot.data;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: const BoxDecoration(
                    color: cardColor,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: backgroundColor,
                        backgroundImage:
                        pet != null && pet.imagePath.isNotEmpty
                            ? FileImage(File(pet.imagePath))
                            : null,
                        child: pet == null || pet.imagePath.isEmpty
                            ? const Icon(
                          Icons.pets,
                          color: Colors.teal,
                          size: 42,
                        )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        pet?.name ?? "Dr. Gogo",
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                buildDrawerItem(
                  icon: Icons.pets,
                  title: "Pet Profile",
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PetProfileScreen(),
                      ),
                    );
                    refreshDashboard();
                  },
                ),
                buildDrawerItem(
                  icon: Icons.notifications_rounded,
                  title: "Alerts",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlertsScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.lock_reset,
                  title: "Change Password",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.info_outline,
                  title: "About Dr. Gogo",
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: "Dr. Gogo",
                      applicationVersion: "1.0.0",
                      applicationIcon: const Icon(
                        Icons.pets,
                        color: Colors.teal,
                        size: 36,
                      ),
                      children: const [
                        Text(
                          "Dr. Gogo is a smart pet health monitoring application designed to support pet owners through health, activity, and location tracking.",
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.teal,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget buildPetHeader() {
    return FutureBuilder<PetModel?>(
      future: _petFuture,
      builder: (context, snapshot) {
        final pet = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: Colors.grey.shade200,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Loading pet information...",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: cardColor,
              backgroundImage: pet != null && pet.imagePath.isNotEmpty
                  ? FileImage(File(pet.imagePath))
                  : null,
              child: pet == null || pet.imagePath.isEmpty
                  ? const Icon(
                Icons.pets,
                color: Colors.teal,
                size: 30,
              )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${pet?.name ?? "Pet"} 🐾",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Monitor your pet’s health and activity",
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPulseCard() {
    return StreamBuilder<DatabaseEvent>(
      stream: sensorRef.onValue,
      builder: (context, snapshot) {
        int heartRate = 0;

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          heartRate = (data["heartRate"] ?? 0).toInt();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.pink.shade100,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Live Pulse",
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "$heartRate",
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            "BPM",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 10,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;

  DashboardItem(this.title, this.icon, this.color);
}