import 'dart:ui';

enum LanguageType {
  en('영어', 'en', Locale('en', 'US')),
  ko('한국어', 'ko', Locale('ko', 'KR'));

  final String text;
  final String enText;
  final Locale locale;

  const LanguageType(
      this.text,
      this.enText,
      this.locale,
      );

  bool get isEn => this == LanguageType.en;
  bool get isKo => this == LanguageType.ko;
}
