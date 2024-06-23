import 'package:example/gh_i18n_language.dart';

class GhI18nTranslations {
  final GhI18nLanguage koKr;
  final GhI18nLanguage enEu;

  GhI18nTranslations({
    required this.koKr,
    required this.enEu,
  });

  Map<String, Map<String, dynamic>> toTranslationKeys() {
    return {
      'ko_KR': koKr.toJson(),
      'en_US': enEu.toJson(),
    };
  }
}