// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AppLocalizations {
//   final Locale locale;
//   AppLocalizations(this.locale);
//
//   static const LocalizationsDelegate<AppLocalizations> delegate =
//   _AppLocalizationsDelegate();
//
//   static AppLocalizations of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(
//         context, AppLocalizations)!;
//   }
//
//   late Map<String, String> _strings;
//
//   Future<void> load() async {
//     final jsonString = await rootBundle
//         .loadString('lib/l10n/${locale.languageCode}.json');
//
//     final Map<String, dynamic> jsonMap = json.decode(jsonString);
//
//     _strings =
//         jsonMap.map((k, v) => MapEntry(k, v.toString()));
//   }
//
//   String tr(String key) => _strings[key] ?? key;
// }
//
// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//
//   @override
//   bool isSupported(Locale locale) =>
//       ['en', 'nl'].contains(locale.languageCode);
//
//   @override
//   Future<AppLocalizations> load(Locale locale) async {
//     final l = AppLocalizations(locale);
//     await l.load();
//     return l;
//   }
//
//   @override
//   bool shouldReload(_) => false;
// }
