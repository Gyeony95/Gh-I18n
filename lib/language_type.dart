import 'dart:ui';

enum LanguageType {
  en('en', Locale('en', 'US')),
  ko('ko', Locale('ko', 'KR'));

  final String text;
  final Locale locale;

  const LanguageType(
    this.text,
    this.locale,
  );

  bool get isEn => this == LanguageType.en;

  bool get isKo => this == LanguageType.ko;
}
