import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Landing
      'home': 'Home',
      'complaints': 'Complaints',
      'calls': 'Calls',
      'profile': 'Profile',

      // Profile View
      'phone': 'Phone',
      'email': 'Email',
      'aadhar_no': 'Aadhar No',
      'badges_earned': 'Badges Earned',
      'top_reporter': 'Top Reporter',
      'x_complaints': '@count Complaints',
      'verified_user': 'Verified User',
      'logout': 'Logout',
      'user_profile': 'User Profile',

      // Register User
      'register_user': 'Register User',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'aadhaar_number': 'Aadhaar Number',
      'submit': 'Submit',

      // Home View
      'search_for_ekyc': 'Search for "ekyc"',
      'progress_for_your_last_complaint': 'Progress for your last complaint',
      'x_completed': '@count/@total completed',
      'pending': 'Pending',
      'completed': 'Completed',

      // Emergency Numbers View
      'emergency_numbers': 'Emergency Numbers',
      'police': 'Police',
      'fire': 'Fire',
      'ambulance': 'Ambulance',
      'national_emergency': 'National Emergency',
      'women_helpline': 'Women Helpline',
      'child_helpline': 'Child Helpline',

      // Add Complaint View
      'register_a_complaint': 'Register a Complaint',
      'capture_image': 'Capture Image',
      'fetching_location': 'Fetching location...',
      'enter_complaint_description': 'Enter complaint description...',
      'record_audio_max_25s': 'Record Audio (max 25s)',
      'recording_tap_to_stop': 'Recording... Tap to Stop',
      'audio_recorded': 'Audio Recorded ✓',
      'submit_complaint': 'Submit Complaint',
      'please_fill_all_required_fields': 'Please fill all required fields',
      'complaint_submitted_successfully': 'Complaint submitted successfully!',

      // Complaint Status View
      'track_complaints': 'Track Complaints',
      'id': 'ID',
      'status': 'Status',
      'registered_on': 'Registered on',
      'photo_attached': 'Photo Attached',
      'no_photo_attached': 'No photo attached',
      'voice_note_attached': 'Voice Note Attached',
      'no_voice_attached': 'No voice attached',
      'submitted': 'Submitted',
      'progress': 'Progress',
      'resolved': 'Resolved',
      'x_percent_completed': '@percent% completed',

      // Authentication Landing
      'sign_up_login': 'Sign Up / Login',
      'password': 'Password',
      'register': 'Register',
      'login': 'Login',
      'processing': 'Processing...',
      'checking': 'Checking...',

      //main
      'security_alert': 'Security Alert',
      'security_alert_message':
          'Developer options are enabled or device is rooted/jailbroken. Please disable them to continue.',
      'exit': 'Exit',
      'checking_security': 'Checking security...',
      'app_title': 'Civic Service App',
      'government_of_india': 'Government Of India',
    },
    'hi': {
      // App Landing
      'home': 'होम',
      'complaints': 'शिकायतें',
      'calls': 'कॉल',
      'profile': 'प्रोफाइल',

      // Profile View
      'phone': 'फ़ोन',
      'email': 'ईमेल',
      'aadhar_no': 'आधार नंबर',
      'badges_earned': 'अर्जित बैज',
      'top_reporter': 'शीर्ष रिपोर्टर',
      'x_complaints': '@count शिकायतें',
      'verified_user': 'सत्यापित उपयोगकर्ता',
      'logout': 'लॉग आउट',
      'user_profile': 'उपयोगकर्ता प्रोफ़ाइल',

      // Register User
      'register_user': 'उपयोगकर्ता पंजीकरण',
      'full_name': 'पूरा नाम',
      'phone_number': 'फ़ोन नंबर',
      'aadhaar_number': 'आधार नंबर',
      'submit': 'जमा करें',

      // Home View
      'search_for_ekyc': '"ekyc" खोजें',
      'progress_for_your_last_complaint': 'आपकी अंतिम शिकायत की प्रगति',
      'x_completed': '@count/@total पूर्ण',
      'pending': 'लंबित',
      'completed': 'पूर्ण',

      // Emergency Numbers View
      'emergency_numbers': 'आपातकालीन नंबर',
      'police': 'पुलिस',
      'fire': 'अग्निशमन',
      'ambulance': 'एम्बुलेंस',
      'national_emergency': 'राष्ट्रीय आपातकाल',
      'women_helpline': 'महिला हेल्पलाइन',
      'child_helpline': 'चाइल्ड हेल्पलाइन',

      // Add Complaint View
      'register_a_complaint': 'शिकायत दर्ज करें',
      'capture_image': 'छवि कैप्चर करें',
      'fetching_location': 'स्थान प्राप्त किया जा रहा है...',
      'enter_complaint_description': 'शिकायत विवरण दर्ज करें...',
      'record_audio_max_25s': 'ऑडियो रिकॉर्ड करें (अधिकतम 25s)',
      'recording_tap_to_stop': 'रिकॉर्डिंग... रोकने के लिए टैप करें',
      'audio_recorded': 'ऑडियो रिकॉर्ड किया गया ✓',
      'submit_complaint': 'शिकायत जमा करें',
      'please_fill_all_required_fields': 'कृपया सभी आवश्यक फ़ील्ड भरें',
      'complaint_submitted_successfully': 'शिकायत सफलतापूर्वक जमा की गई!',

      // Complaint Status View
      'track_complaints': 'शिकायतों को ट्रैक करें',
      'id': 'आईडी',
      'status': 'स्थिति',
      'registered_on': 'पंजीकरण तिथि',
      'photo_attached': 'फोटो संलग्न',
      'no_photo_attached': 'कोई फोटो संलग्न नहीं',
      'voice_note_attached': 'वॉयस नोट संलग्न',
      'no_voice_attached': 'कोई वॉइस संलग्न नहीं',
      'submitted': 'जमा किया गया',
      'progress': 'प्रगति पर',
      'resolved': 'हल हो गया',
      'x_percent_completed': '@percent% पूर्ण',

      // Authentication Landing
      'sign_up_login': 'साइन अप / लॉगिन',
      'password': 'पासवर्ड',
      'register': 'पंजीकरण',
      'login': 'लॉगिन',
      'processing': 'प्रसंस्करण...',
      'checking': 'जाँच...',

      'security_alert': 'सुरक्षा चेतावनी',
      'security_alert_message':
          'डेवलपर विकल्प सक्षम हैं या डिवाइस रूटेड/जेलब्रेक है। जारी रखने के लिए कृपया उन्हें अक्षम करें।',
      'exit': 'बाहर निकलें',
      'checking_security': 'सुरक्षा जाँच की जा रही है...',
      'app_title': 'नागरिक सेवा ऐप',
      'government_of_india': 'भारत सरकार',
    },
    'bn': {
      // App Landing
      'home': 'হোম',
      'complaints': 'অভিযোগ',
      'calls': 'কল',
      'profile': 'প্রোফাইল',

      // Profile View
      'phone': 'ফোন',
      'email': 'ইমেইল',
      'aadhar_no': 'আধার নম্বর',
      'badges_earned': 'অর্জিত ব্যাজ',
      'top_reporter': 'শীর্ষ প্রতিবেদক',
      'x_complaints': '@countটি অভিযোগ',
      'verified_user': 'যাচাইকৃত ব্যবহারকারী',
      'logout': 'লগআউট',
      'user_profile': 'ব্যবহারকারীর প্রোফাইল',

      // Register User
      'register_user': 'ব্যবহারকারী নিবন্ধন',
      'full_name': 'পুরো নাম',
      'phone_number': 'ফোন নম্বর',
      'aadhaar_number': 'আধার নম্বর',
      'submit': 'জমা দিন',

      // Home View
      'search_for_ekyc': '"ekyc" অনুসন্ধান করুন',
      'progress_for_your_last_complaint': 'আপনার শেষ অভিযোগের অগ্রগতি',
      'x_completed': '@count/@total সম্পন্ন',
      'pending': 'বিচারাধীন',
      'completed': 'সম্পন্ন',

      // Emergency Numbers View
      'emergency_numbers': 'জরুরী নম্বর',
      'police': 'পুলিশ',
      'fire': 'ফায়ার',
      'ambulance': 'অ্যাম্বুলেন্স',
      'national_emergency': 'জাতীয় জরুরী',
      'women_helpline': 'মহিলা হেল্পলাইন',
      'child_helpline': 'চাইল্ড হেল্পলাইন',

      // Add Complaint View
      'register_a_complaint': 'অভিযোগ নিবন্ধন করুন',
      'capture_image': 'ছবি তোলুন',
      'fetching_location': 'অবস্থান আনয়ন করা হচ্ছে...',
      'enter_complaint_description': 'অভিযোগের বিবরণ লিখুন...',
      'record_audio_max_25s': 'অডিও রেকর্ড করুন (সর্বোচ্চ 25s)',
      'recording_tap_to_stop': 'রেকর্ডিং হচ্ছে... বন্ধ করতে ট্যাপ করুন',
      'audio_recorded': 'অডিও রেকর্ড করা হয়েছে ✓',
      'submit_complaint': 'অভিযোগ জমা দিন',
      'please_fill_all_required_fields':
          'দয়া করে সমস্ত প্রয়োজনীয় ক্ষেত্র পূরণ করুন',
      'complaint_submitted_successfully': 'অভিযোগ সফলভাবে জমা দেওয়া হয়েছে!',

      // Complaint Status View
      'track_complaints': 'অভিযোগ ট্র্যাক করুন',
      'id': 'আইডি',
      'status': 'স্থিতি',
      'registered_on': 'নিবন্ধনের তারিখ',
      'photo_attached': 'ফটো সংযুক্ত',
      'no_photo_attached': 'কোন ফটো সংযুক্ত নেই',
      'voice_note_attached': 'ভয়েস নোট সংযুক্ত',
      'no_voice_attached': 'কোন ভয়েস সংযুক্ত নেই',
      'submitted': 'জমা দেওয়া হয়েছে',
      'progress': 'অগ্রগতি',
      'resolved': 'সমাধান হয়েছে',
      'x_percent_completed': '@percent% সম্পন্ন',

      // Authentication Landing
      'sign_up_login': 'নিবন্ধন / লগইন',
      'password': 'পাসওয়ার্ড',
      'register': 'নিবন্ধন',
      'login': 'লগইন',
      'processing': 'প্রক্রিয়াকরণ...',
      'checking': 'পরীক্ষা করা হচ্ছে...',

      'security_alert': 'সুরক্ষা সতর্কতা',
      'security_alert_message':
          'ডেভেলপার অপশন সক্ষম আছে বা ডিভাইস রুটেড/জেলব্রেক করা হয়েছে। চালিয়ে যেতে দয়া করে সেগুলি অক্ষম করুন।',
      'exit': 'প্রস্থান',
      'checking_security': 'সুরক্ষা পরীক্ষা করা হচ্ছে...',
      'app_title': 'সিভিক সার্ভিস অ্যাপ',
      'government_of_india': 'ভারত সরকার',
    },
  };

  String translate(String key, [List<String>? args]) {
    String value = _localizedValues[locale.languageCode]?[key] ?? '[$key]';

    if (args != null && args.isNotEmpty) {
      for (int i = 0; i < args.length; i++) {
        value = value.replaceAll('@${i + 1}', args[i]);
      }
    }

    // Handle special placeholders
    if (value.contains('@count') && args != null && args.isNotEmpty) {
      value = value.replaceAll('@count', args[0]);
    }

    if (value.contains('@total') && args != null && args.length > 1) {
      value = value.replaceAll('@total', args[1]);
    }

    if (value.contains('@percent') && args != null && args.isNotEmpty) {
      value = value.replaceAll('@percent', args[0]);
    }

    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
