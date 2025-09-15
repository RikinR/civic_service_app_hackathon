import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ComplaintStatusView extends StatelessWidget {
  const ComplaintStatusView({super.key});

  final List<Map<String, dynamic>> complaints = const [
    {
      "id": "CMP-1001",
      "date": "2025-09-12",
      "status": "Submitted",
      "progress": 1,
      "totalSteps": 3,
      "hasImage": false,
      "hasVoice": false,
    },
    {
      "id": "CMP-1002",
      "date": "2025-09-10",
      "status": "Pending",
      "progress": 2,
      "totalSteps": 3,
      "hasImage": true,
      "hasVoice": true,
    },
    {
      "id": "CMP-1003",
      "date": "2025-09-08",
      "status": "Resolved",
      "progress": 3,
      "totalSteps": 3,
      "hasImage": true,
      "hasVoice": false,
    },
  ];

  Color _getProgressColor(String status) {
    switch (status) {
      case "Submitted":
        return Colors.redAccent;
      case "Pending":
        return Colors.amber;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.tertiary.withAlpha(175),
              colorScheme.primary.withAlpha(50),
              colorScheme.primary.withAlpha(25),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Register a Complaint',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    final percent =
                        complaint["progress"] /
                        complaint["totalSteps"]; 
                    final status = complaint["status"];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearPercentIndicator(
                            lineHeight: 30.0,
                            percent: percent,
                            backgroundColor: Colors.grey.shade200,
                            progressColor: _getProgressColor(status),
                            barRadius: const Radius.circular(12),
                            center: Text(
                              "${complaint["progress"]}/${complaint["totalSteps"]} completed",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ID: ${complaint["id"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: _getProgressColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Registered on: ${complaint["date"]}"),

                          const Divider(height: 24),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                complaint["hasImage"]
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(width: 6),
                                            Text("Photo Attached"),
                                          ],
                                        ),
                                      )
                                    : const Text(
                                        "No photo attached",
                                        style: TextStyle(color: Colors.grey),
                                      ),

                                const SizedBox(width: 16),

                                complaint["hasVoice"]
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.audiotrack,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 6),
                                            Text("Voice Note Attached"),
                                          ],
                                        ),
                                      )
                                    : const Text(
                                        "No voice attached",
                                        style: TextStyle(color: Colors.grey),
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
      ),
    );
  }
}