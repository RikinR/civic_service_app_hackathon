import 'package:civic_service_app/view/authentication_views/authentication_landing.dart';
import 'package:civic_service_app/widgets/header/header_buttons.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Image.asset('assets/govt_logo.png', height: 50),
              Text('Government Of India'),
            ],
          ),
        ),
        Spacer(),
        HeaderButtons(icon: Icons.translate_rounded),
        HeaderButtons(icon: Icons.notifications_none),
        HeaderButtons(icon: Icons.chat_bubble_outline),
        SizedBox(width: 6),
      ],
    );
  }
}
