import 'package:flutter/material.dart';

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({super.key, this.toPage, required this.icon});
  final Function()? toPage;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(onTap: toPage, child: Icon(icon, size: 25)),
    );
  }
}
