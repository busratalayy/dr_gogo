import 'package:flutter/material.dart';

class HealthVaccineScreen extends StatefulWidget {
  const HealthVaccineScreen({super.key});

  @override
  State<HealthVaccineScreen> createState() =>
      _HealthVaccineScreenState();
}

class _HealthVaccineScreenState
    extends State<HealthVaccineScreen> {

  static const Color backgroundColor =
  Color(0xFFF7F4EF);

  static const Color cardColor =
  Color(0xFFFDFDFB);

  static const Color textColor =
  Color(0xFF1F1F1F);

  static const Color subtitleColor =
  Color(0xFF6E6E6E);

  static const Color accentColor =
  Color(0xFF6FAFA6);

  // Fake vaccine list
  List<Map<String, String>> vaccines = [
    {
      "name": "Rabies Vaccine",
      "date": "12/3/2026",
      "next": "12/3/2027",
    },
    {
      "name": "Internal Parasite",
      "date": "20/4/2026",
      "next": "20/7/2026",
    },
  ];

  final TextEditingController vaccineNameController =
  TextEditingController();

  DateTime? selectedDate;

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
                  borderRadius:
                  BorderRadius.circular(14),
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

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

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

              child: ListView.builder(

                itemCount: vaccines.length,

                itemBuilder: (context, index) {

                  final vaccine = vaccines[index];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                        bottom: 18),

                    padding:
                    const EdgeInsets.all(20),

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

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            // Icon
                            Container(

                              width: 58,
                              height: 58,

                              decoration:
                              BoxDecoration(

                                color: Colors.red
                                    .withOpacity(
                                    0.12),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    18),
                              ),

                              child: const Icon(
                                Icons.vaccines,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Vaccine Info
                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(
                                    vaccine["name"]!,
                                    style:
                                    const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color:
                                      textColor,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 6),

                                  Text(
                                    "Last Vaccine: ${vaccine["date"]}",
                                    style:
                                    const TextStyle(
                                      color:
                                      subtitleColor,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 4),

                                  Text(
                                    "Next Reminder: ${vaccine["next"]}",
                                    style:
                                    const TextStyle(
                                      color:
                                      subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Edit Button
                            GestureDetector(

                              onTap: () {

                                showVaccineDialog(
                                  editIndex: index,
                                );
                              },

                              child: Container(

                                width: 42,
                                height: 42,

                                decoration:
                                BoxDecoration(

                                  color: accentColor
                                      .withOpacity(
                                      0.12),

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      14),
                                ),

                                child: const Icon(
                                  Icons.edit,
                                  color:
                                  accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Status Card
                        Container(

                          padding:
                          const EdgeInsets.all(
                              16),

                          decoration: BoxDecoration(

                            color: const Color(
                                0xFFFFF8E7),

                            borderRadius:
                            BorderRadius
                                .circular(18),
                          ),

                          child: const Row(

                            children: [

                              Icon(
                                Icons.info_outline,
                                color:
                                Colors.orange,
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  "Vaccination record looks up to date.",
                                  style:
                                  TextStyle(
                                    color:
                                    subtitleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add / Edit Dialog
  void showVaccineDialog({
    int? editIndex,
  }) {

    selectedDate = null;

    if (editIndex != null) {

      vaccineNameController.text =
      vaccines[editIndex]["name"]!;

    } else {

      vaccineNameController.clear();
    }

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          backgroundColor: cardColor,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),

          title: Text(
            editIndex == null
                ? "Add Vaccine"
                : "Edit Vaccine",
          ),

          content: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(

                controller:
                vaccineNameController,

                decoration: InputDecoration(

                  labelText: "Vaccine Name",

                  filled: true,

                  fillColor:
                  const Color(0xFFF4F4F2),

                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        16),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(

                onTap: () async {

                  DateTime? pickedDate =
                  await showDatePicker(

                    context: context,

                    initialDate:
                    DateTime.now(),

                    firstDate:
                    DateTime(2020),

                    lastDate:
                    DateTime(2035),
                  );

                  if (pickedDate != null) {

                    setState(() {

                      selectedDate =
                          pickedDate;
                    });
                  }
                },

                child: Container(

                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(
                      16),

                  decoration: BoxDecoration(

                    color: const Color(
                        0xFFF4F4F2),

                    borderRadius:
                    BorderRadius.circular(
                        16),
                  ),

                  child: Text(

                    selectedDate == null
                        ? "Select Vaccine Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                    style: const TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                accentColor,
              ),

              onPressed: () {

                if (vaccineNameController
                    .text
                    .isEmpty) return;

                String formattedDate =
                selectedDate == null
                    ? "No Date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

                if (editIndex == null) {

                  vaccines.add({

                    "name":
                    vaccineNameController
                        .text,

                    "date":
                    formattedDate,

                    "next":
                    "Next Year",
                  });

                } else {

                  vaccines[editIndex] = {

                    "name":
                    vaccineNameController
                        .text,

                    "date":
                    formattedDate,

                    "next":
                    "Updated Reminder",
                  };
                }

                setState(() {});

                Navigator.pop(context);
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
  }
}