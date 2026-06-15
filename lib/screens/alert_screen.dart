import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get ownerId => auth.currentUser!.uid;

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedType = "Food";

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> addReminder() async {
    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      return;
    }

    await firestore.collection("reminders").add({
      "ownerId": ownerId,
      "title": titleController.text.trim(),
      "message": messageController.text.trim(),
      "type": selectedType,
      "reminderDate": Timestamp.fromDate(selectedDate!),
      "reminderTime":
      "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
      "isRead": false,
      "createdAt": FieldValue.serverTimestamp(),
    });

    titleController.clear();
    messageController.clear();
    selectedDate = null;
    selectedTime = null;
    selectedType = "Food";
  }

  void showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                "Create Reminder",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: "Type"),
                      items: const [
                        DropdownMenuItem(value: "Food", child: Text("Food")),
                        DropdownMenuItem(value: "Water", child: Text("Water")),
                        DropdownMenuItem(value: "Custom", child: Text("Custom")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value ?? "Food";
                        });
                      },
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: "Message",
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2035),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        selectedDate == null
                            ? "Select Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime == null
                            ? "Select Time"
                            : selectedTime!.format(context),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                  ),
                  onPressed: () async {
                    await addReminder();

                    if (!mounted) return;
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int daysLeft(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.difference(todayOnly).inDays;
  }

  String vaccineStatusText(int days) {
    if (days < 0) return "Overdue";
    if (days == 0) return "Due today";
    if (days == 1) return "Due tomorrow";
    return "Due in $days days";
  }

  IconData getReminderIcon(String type) {
    if (type == "Food") return Icons.restaurant;
    if (type == "Water") return Icons.water_drop;
    return Icons.notifications;
  }

  Color getReminderColor(String type) {
    if (type == "Food") return Colors.orange;
    if (type == "Water") return Colors.blue;
    return Colors.teal;
  }

  Future<void> markReminderAsRead(String docId) async {
    await firestore.collection("reminders").doc(docId).update({
      "isRead": true,
    });
  }

  @override
  Widget build(BuildContext context) {
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

            final upcomingVaccines = vaccines.where((doc) {
              final data = doc.data();
              final next = data["next"];

              if (next == null) return false;

              final date = (next as Timestamp).toDate();
              final days = daysLeft(date);

              return days <= 7;
            }).toList();

            final notificationCount =
                unreadReminderCount + upcomingVaccines.length;

            return Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                title: const Text(
                  "Alerts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                centerTitle: true,
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: showAddReminderDialog,
                    icon: const Icon(Icons.add_alert),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavBar(
                currentIndex: 1,
                notificationCount: notificationCount,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alerts 🔔",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Upcoming vaccines and custom care reminders.",
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        children: [
                          ...upcomingVaccines.map((doc) {
                            final data = doc.data();
                            final name = data["name"] ?? "Vaccine";
                            final next = (data["next"] as Timestamp).toDate();
                            final days = daysLeft(next);

                            return buildAlertCard(
                              title: "Upcoming Vaccine",
                              message: "$name ${vaccineStatusText(days)}.",
                              time:
                              "${next.day}/${next.month}/${next.year}",
                              icon: Icons.vaccines,
                              color: Colors.purple,
                              isUnread: true,
                              onTap: () {},
                            );
                          }),

                          ...reminders.map((doc) {
                            final data = doc.data();
                            final type = data["type"] ?? "Custom";
                            final title = data["title"] ?? "";
                            final message = data["message"] ?? "";
                            final time = data["reminderTime"] ?? "";
                            final isRead = data["isRead"] == true;

                            return buildAlertCard(
                              title: title,
                              message: message,
                              time: time,
                              icon: getReminderIcon(type),
                              color: getReminderColor(type),
                              isUnread: !isRead,
                              onTap: () => markReminderAsRead(doc.id),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildAlertCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(
                      color: subtitleColor,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
}