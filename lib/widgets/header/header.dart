import 'package:civic_service_app/widgets/header/header_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:civic_service_app/providers/language_provider.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Image.asset('assets/govt_logo.png', height: 50),
              Text(AppLocalizations.of(context)!.translate('government_of_india')),
            ],
          ),
        ),
        const Spacer(),
        // Language dropdown button
        PopupMenuButton<Locale>(
          icon: const Icon(Icons.translate_rounded, color: Colors.black),
          onSelected: (Locale newLocale) {
            languageProvider.setLocale(newLocale);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
            const PopupMenuItem<Locale>(
              value: Locale('en'),
              child: Text('English'),
            ),
            const PopupMenuItem<Locale>(
              value: Locale('hi'),
              child: Text('हिंदी'),
            ),
            const PopupMenuItem<Locale>(
              value: Locale('bn'),
              child: Text('বাংলা'),
            ),
          ],
        ),
        const SizedBox(width: 8),
        HeaderButtons(icon: Icons.notifications_none),
        HeaderButtons(icon: Icons.chat_bubble_outline),
        const SizedBox(width: 6),
      ],
    );
  }
}