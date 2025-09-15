import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class EmergencyNumbersView extends StatelessWidget {
  const EmergencyNumbersView({super.key});

  Future<void> _makeCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch $number: $e");
    }
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String labelKey,
    required String number,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.translate(labelKey),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "[$number]",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Card(
            elevation: 0,
            color: color.withAlpha(40),
            child: IconButton(
              onPressed: () => _makeCall(number),
              icon: Icon(Icons.call, color: color),
            ),
          ),
        ],
      ),
    );
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
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  AppLocalizations.of(context)!.translate('emergency_numbers'),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildEmergencyButton(
                      icon: Icons.local_police,
                      labelKey: "police",
                      number: "100",
                      color: Colors.blue,
                      context: context,
                    ),
                    _buildEmergencyButton(
                      icon: Icons.local_fire_department,
                      labelKey: "fire",
                      number: "101",
                      color: Colors.red,
                      context: context,
                    ),
                    _buildEmergencyButton(
                      icon: Icons.local_hospital,
                      labelKey: "ambulance",
                      number: "102",
                      color: Colors.green,
                      context: context,
                    ),
                    _buildEmergencyButton(
                      icon: Icons.emergency,
                      labelKey: "national_emergency",
                      number: "112",
                      color: Colors.deepPurple,
                      context: context,
                    ),
                    _buildEmergencyButton(
                      icon: Icons.woman,
                      labelKey: "women_helpline",
                      number: "1091",
                      color: Colors.orange,
                      context: context,
                    ),
                    _buildEmergencyButton(
                      icon: Icons.child_care,
                      labelKey: "child_helpline",
                      number: "1098",
                      color: Colors.pink,
                      context: context,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
