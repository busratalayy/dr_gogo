import 'package:flutter/material.dart';
import '../services/rest_monitoring_service.dart';

class RestMonitoringScreen extends StatelessWidget {
  const RestMonitoringScreen({super.key});

  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);

  @override
  Widget build(BuildContext context) {

    // Fake motion value
    double motionLevel = 1.02;

    String restStatus =
    RestMonitoringService.getRestStatus(
        motionLevel);

    String movementLevel =
    RestMonitoringService.getMovementLevel(
        motionLevel);

    String summary =
    RestMonitoringService.getRestSummary(
        motionLevel);

    return Scaffold(

      backgroundColor: backgroundColor,

      appBar: AppBar(

        title: const Text(
          "Rest Monitoring",
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

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Rest Analysis 🌙",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Monitor your pet’s resting and low activity behavior.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            // Main Rest Card
            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(26),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(30),

                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade300,
                    Colors.deepPurple.shade400,
                  ],
                ),

                boxShadow: [

                  BoxShadow(
                    color: Colors.indigo
                        .withOpacity(0.25),

                    blurRadius: 20,

                    offset:
                    const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(

                children: [

                  const Icon(
                    Icons.nightlight_round,
                    color: Colors.white,
                    size: 54,
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
                    restStatus,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Cards
            GridView.count(

              crossAxisCount: 2,

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              crossAxisSpacing: 16,

              mainAxisSpacing: 16,

              childAspectRatio: 1,

              children: [

                buildInfoCard(
                  title: "Rest Duration",
                  value: "2h 14m",
                  icon: Icons.timer,
                  iconColor: Colors.orange,
                ),

                buildInfoCard(
                  title: "Movement Level",
                  value: movementLevel,
                  icon: Icons.show_chart,
                  iconColor: Colors.blue,
                ),

                buildInfoCard(
                  title: "Last Activity",
                  value: "Walking",
                  icon: Icons.pets,
                  iconColor: Colors.green,
                ),

                buildInfoCard(
                  title: "Motion Value",
                  value:
                  motionLevel.toString(),
                  icon: Icons.insights,
                  iconColor: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 26),

            // Summary Card
            Container(

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color: cardColor,

                borderRadius:
                BorderRadius.circular(26),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),

                    blurRadius: 16,

                    offset:
                    const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Container(

                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(

                      color: Colors.indigo
                          .withOpacity(0.12),

                      borderRadius:
                      BorderRadius.circular(
                          18),
                    ),

                    child: const Icon(
                      Icons.self_improvement,
                      color: Colors.indigo,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        const Text(
                          "Daily Rest Summary",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          summary,
                          style: const TextStyle(
                            color:
                            subtitleColor,
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

        borderRadius:
        BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(0.05),

            blurRadius: 16,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

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
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
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
}