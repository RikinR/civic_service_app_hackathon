import 'package:civic_service_app/l10n/app_localizations.dart';
import 'package:civic_service_app/viewmodel/auth_view_model.dart';
import 'package:civic_service_app/viewmodel/user_viewmodel.dart'; // Import the user viewmodel
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String fullName = '';
  String phoneNo = '';
  String email = '';
  String aadhaarNo = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // First load from SharedPreferences as fallback
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'John Doe';
      phoneNo = prefs.getString('phoneNo') ?? '+91 9876543210';
      email = prefs.getString('email') ?? 'email@email.com';
    });

    // Then try to fetch from Firestore
    try {
      final userVM = Provider.of<RegisterUserViewModel>(context, listen: false);
      await userVM.fetchCurrentUser();

      if (userVM.user != null) {
        setState(() {
          fullName = userVM.user!.fullName;
          phoneNo = userVM.user!.phoneNo;
          email = userVM.user!.email;
          aadhaarNo = userVM.user!.aadhaarNo;
        });

        // Update SharedPreferences with fresh data
        await prefs.setString('fullName', fullName);
        await prefs.setString('phoneNo', phoneNo);
        await prefs.setString('email', email);
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      // If Firestore fetch fails, we'll use the SharedPreferences data
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.secondary.withAlpha(200),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('user_profile'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: AppLocalizations.of(
                            context,
                          )!.translate('phone'),
                          value: phoneNo,
                        ),
                        _DetailRow(
                          label: AppLocalizations.of(
                            context,
                          )!.translate('email'),
                          value: email,
                        ),
                        _DetailRow(
                          label: AppLocalizations.of(
                            context,
                          )!.translate('aadhar_no'),
                          value: aadhaarNo.isNotEmpty
                              ? _maskAadhaar(aadhaarNo)
                              : "xxxxxxxxxx",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.translate('badges_earned'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildBadge(
                      Icons.emoji_events,
                      AppLocalizations.of(context)!.translate('top_reporter'),
                      Colors.amber,
                    ),
                    _buildBadge(
                      Icons.star,
                      AppLocalizations.of(
                        context,
                      )!.translate('x_complaints', ['5']),
                      Colors.blue,
                    ),
                    _buildBadge(
                      Icons.verified,
                      AppLocalizations.of(context)!.translate('verified_user'),
                      Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final authVM = Provider.of<AuthViewModel>(
                        context,
                        listen: false,
                      );
                      await authVM.logout(context);
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.logout_outlined),
                    label: Text(
                      AppLocalizations.of(context)!.translate('logout'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _maskAadhaar(String aadhaar) {
    if (aadhaar.length <= 4) return aadhaar;
    return '${'x' * (aadhaar.length - 4)}${aadhaar.substring(aadhaar.length - 4)}';
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: color.withAlpha(75),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
