import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Başlık
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
              "Monitor your pet’s daily movement and activity level.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            // Current Status
            buildMainStatusCard(),

            const SizedBox(height: 22),

            // Grid Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,

              children: [

                buildInfoCard(
                  title: "Distance",
                  value: "1.84 km",
                  icon: Icons.location_on,
                  iconColor: Colors.green,
                ),

                buildInfoCard(
                  title: "Active Time",
                  value: "42 min",
                  icon: Icons.timer,
                  iconColor: Colors.orange,
                ),

                buildInfoCard(
                  title: "Motion Level",
                  value: "Moderate",
                  icon: Icons.show_chart,
                  iconColor: Colors.blue,
                ),

                buildInfoCard(
                  title: "Estimated Steps",
                  value: "2,340",
                  icon: Icons.pets,
                  iconColor: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Daily Summary
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),

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

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Daily Summary",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Your pet showed a healthy level of movement today.",
                          style: TextStyle(
                            color: subtitleColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ana status kartı
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

          const Icon(
            Icons.directions_run,
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

          const Text(
            "Walking",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Küçük bilgi kartları
  Widget buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          CircleAvatar(
            radius: 28,
            backgroundColor:
            iconColor.withOpacity(0.12),

            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}