import 'package:civic_service_app/view/complaint_views/add_complaint_landing.dart';
import 'package:civic_service_app/view/complaint_views/track_complaint.dart';
import 'package:civic_service_app/view/emergency_numbers_views/emergency_numbers_view.dart';
import 'package:civic_service_app/view/home_views/home_view.dart';
import 'package:civic_service_app/view/profile_page_views/profile_landing.dart';
import 'package:flutter/material.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class AppLanding extends StatefulWidget {
  const AppLanding({super.key});

  @override
  State<AppLanding> createState() => _AppLandingState();
}

class _AppLandingState extends State<AppLanding> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    ComplaintStatusWrapper(),
    AddComplaintWrapper(),
    EmergencyNumbersView(),
    ProfileWrapper(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Colors.black54;

    return Scaffold(
      body: _pages[_selectedIndex],

      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(top: 40),
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF2F7AFB),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      Icons.home,
                      "home",
                      0,
                      activeColor,
                      inactiveColor,
                    ),
                    _buildNavItem(
                      Icons.insert_chart_outlined_outlined,
                      "complaints",
                      1,
                      activeColor,
                      inactiveColor,
                    ),
                  ],
                ),
              ),

              // Spacer for the FAB
              const SizedBox(width: 40),

              // Right side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      Icons.call,
                      "calls",
                      3,
                      activeColor,
                      inactiveColor,
                    ),
                    _buildNavItem(
                      Icons.person_2_outlined,
                      "profile",
                      4,
                      activeColor,
                      inactiveColor,
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

  Widget _buildNavItem(
    IconData icon,
    String labelKey,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor),
          Text(
            AppLocalizations.of(context)!.translate(labelKey),
            style: TextStyle(
              fontSize: 12,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
