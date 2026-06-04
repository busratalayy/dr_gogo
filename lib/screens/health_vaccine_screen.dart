import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dr_gogo/widgets/bottom_nav_bar.dart';

class HealthVaccineScreen extends StatefulWidget {
  const HealthVaccineScreen({super.key});

  @override
  State<HealthVaccineScreen> createState() => _HealthVaccineScreenState();
}

class _HealthVaccineScreenState extends State<HealthVaccineScreen> {
  static const Color backgroundColor = Color(0xFFF7F4EF);
  static const Color cardColor = Color(0xFFFDFDFB);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color subtitleColor = Color(0xFF6E6E6E);
  static const Color accentColor = Color(0xFF6FAFA6);

  final TextEditingController vaccineNameController = TextEditingController();

  DateTime? selectedDate;
  DateTime? nextReminderDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get ownerId => _auth.currentUser!.uid;

  @override
  void dispose() {
    vaccineNameController.dispose();
    super.dispose();
  }

  Future<void> addVaccine() async {
    if (vaccineNameController.text.trim().isEmpty || selectedDate == null) {
      return;
    }

    await _firestore.collection('vaccines').add({
      'ownerId': ownerId,
      'name': vaccineNameController.text.trim(),
      'date': Timestamp.fromDate(selectedDate!),
      'next': nextReminderDate != null
          ? Timestamp.fromDate(nextReminderDate!)
          : null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateVaccine(String docId) async {
    if (vaccineNameController.text.trim().isEmpty || selectedDate == null) {
      return;
    }

    await _firestore.collection('vaccines').doc(docId).update({
      'name': vaccineNameController.text.trim(),
      'date': Timestamp.fromDate(selectedDate!),
      'next': nextReminderDate != null
          ? Timestamp.fromDate(nextReminderDate!)
          : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteVaccine(String docId) async {
    await _firestore.collection('vaccines').doc(docId).delete();
  }
  void showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Delete Vaccine Record?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this vaccine record?",
            style: TextStyle(
              color: subtitleColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                await deleteVaccine(docId);

                if (!mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Vaccine record deleted."),
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return "No Date";

    final DateTime date = (timestamp as Timestamp).toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  DateTime? timestampToDate(dynamic timestamp) {
    if (timestamp == null) return null;
    return (timestamp as Timestamp).toDate();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVaccinesStream() {
    return _firestore
        .collection('vaccines')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textColor,
        title: const Text(
          "Health & Vaccine",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () {
                showVaccineDialog();
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vaccination Records 💉",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Track your pet’s vaccination and health history.",
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getVaccinesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: accentColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "An error occurred while loading records.",
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.vaccines,
                            size: 70,
                            color: accentColor.withOpacity(0.8),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No vaccine record found",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tap the + button to add your first record.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final vaccine = doc.data();

                      return buildVaccineCard(
                        docId: doc.id,
                        name: vaccine['name'] ?? '',
                        date: formatDate(vaccine['date']),
                        next: formatDate(vaccine['next']),
                        rawDate: timestampToDate(vaccine['date']),
                        rawNextDate: timestampToDate(vaccine['next']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVaccineCard({
    required String docId,
    required String name,
    required String date,
    required String next,
    required DateTime? rawDate,
    required DateTime? rawNextDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.vaccines,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Last Vaccine: $date",
                      style: const TextStyle(
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Next Reminder: $next",
                      style: const TextStyle(
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  showVaccineDialog(
                    docId: docId,
                    currentName: name,
                    currentDate: rawDate,
                    currentNextDate: rawNextDate,
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: accentColor,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: () {
                  showDeleteConfirmationDialog(docId);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Vaccination record is stored in your pet health history.",
                    style: TextStyle(
                      color: subtitleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showVaccineDialog({
    String? docId,
    String? currentName,
    DateTime? currentDate,
    DateTime? currentNextDate,
  }) {
    final bool isEdit = docId != null;

    vaccineNameController.text = currentName ?? '';
    selectedDate = currentDate;
    nextReminderDate = currentNextDate;

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
              title: Text(
                isEdit ? "Edit Vaccine" : "Add Vaccine",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: vaccineNameController,
                      style: const TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "Vaccine Name",
                        filled: true,
                        fillColor: const Color(0xFFF4F4F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    buildDateSelector(
                      title: selectedDate == null
                          ? "Select Vaccine Date"
                          : "Vaccine Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    buildDateSelector(
                      title: nextReminderDate == null
                          ? "Select Next Reminder Date"
                          : "Next Reminder: ${nextReminderDate!.day}/${nextReminderDate!.month}/${nextReminderDate!.year}",
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: nextReminderDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );

                        if (pickedDate != null) {
                          setDialogState(() {
                            nextReminderDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                  ),
                  onPressed: () async {
                    if (isEdit) {
                      await updateVaccine(docId);
                    } else {
                      await addVaccine();
                    }

                    if (!mounted) return;
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildDateSelector({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}