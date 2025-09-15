import 'package:civic_service_app/viewmodel/complaint_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class ComplaintStatusView extends StatefulWidget {
  const ComplaintStatusView({super.key});

  @override
  State<ComplaintStatusView> createState() => _ComplaintStatusViewState();
}

class _ComplaintStatusViewState extends State<ComplaintStatusView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComplaintViewModel>(
        context,
        listen: false,
      ).fetchUserComplaints();
    });
  }

  Color _getProgressColor(String status) {
    switch (status) {
      case "Submitted":
        return Colors.redAccent;
      case "Progress":
        return Colors.amber;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  double _getProgressPercent(String status) {
    switch (status) {
      case "Submitted":
        return 0.333;
      case "Progress":
        return 0.666;
      case "Resolved":
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _getTranslatedStatus(String status) {
    switch (status) {
      case "Submitted":
        return AppLocalizations.of(context)!.translate('submitted');
      case "Progress":
        return AppLocalizations.of(context)!.translate('progress');
      case "Resolved":
        return AppLocalizations.of(context)!.translate('resolved');
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _dummyComplaints() {
    return [
      {
        "complaintId": "CMP-1001",
        "createdAt": DateTime.now(),
        "status": "Submitted",
        "imageUrl": "",
        "voiceUrl": "",
      },
      {
        "complaintId": "CMP-1002",
        "createdAt": DateTime.now().subtract(const Duration(days: 2)),
        "status": "Progress",
        "imageUrl": "some_image_url",
        "voiceUrl": "some_voice_url",
      },
      {
        "complaintId": "CMP-1003",
        "createdAt": DateTime.now().subtract(const Duration(days: 5)),
        "status": "Resolved",
        "imageUrl": "some_image_url",
        "voiceUrl": "",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final complaintViewModel = Provider.of<ComplaintViewModel>(context);

    final complaints = complaintViewModel.complaints.isNotEmpty
        ? complaintViewModel.complaints
        : _dummyComplaints();

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
                  AppLocalizations.of(context)!.translate('track_complaints'),
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
                    final status = complaint["status"] ?? "Submitted";
                    final translatedStatus = _getTranslatedStatus(status);
                    final percent = _getProgressPercent(status);

                    final hasImage =
                        complaint["imageUrl"] != null &&
                        complaint["imageUrl"].isNotEmpty;
                    final hasVoice =
                        complaint["voiceUrl"] != null &&
                        complaint["voiceUrl"].isNotEmpty;

                    final createdAt = complaint["createdAt"];
                    String formattedDate = 'N/A';
                    if (createdAt != null) {
                      if (createdAt is DateTime) {
                        formattedDate = createdAt.toLocal().toString().split(
                          ' ',
                        )[0];
                      } else if (createdAt is Timestamp) {
                        formattedDate = createdAt
                            .toDate()
                            .toLocal()
                            .toString()
                            .split(' ')[0];
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
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
                              AppLocalizations.of(context)!.translate(
                                'x_percent_completed',
                                [((percent * 100).toStringAsFixed(0))],
                              ),
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
                                "${AppLocalizations.of(context)!.translate('id')}: ${complaint["complaintId"] != null ? (complaint["complaintId"] as String).substring(0, complaint["complaintId"].length > 15 ? 15 : complaint["complaintId"].length) : 'N/A'}...",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "${AppLocalizations.of(context)!.translate('status')}: $translatedStatus",
                                style: TextStyle(
                                  color: _getProgressColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${AppLocalizations.of(context)!.translate('registered_on')}: $formattedDate",
                          ),
                          const Divider(height: 24),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                hasImage
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
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.photo,
                                              color: Colors.orange,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.translate('photo_attached'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.translate('no_photo_attached'),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                const SizedBox(width: 16),
                                hasVoice
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
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.audiotrack,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.translate(
                                                'voice_note_attached',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.translate('no_voice_attached'),
                                        style: const TextStyle(
                                          color: Colors.grey,
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
      ),
    );
  }
}
