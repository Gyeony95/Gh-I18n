// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:gh_i18n/language_type.dart';
//
// /// 전역에서 사용될 수 있게 class 밖에 선언
// GrowLanguage get tl => TranslateHelper()._translateLanguage;
//
// class TranslateHelper {
//   static TranslateHelper? _instance;
//
//   TranslateHelper._() {
//     _instance ??= this;
//   }
//
//   factory TranslateHelper() {
//     return _instance ??= TranslateHelper._();
//   }
//
//   /// key를 통해 번역된 언어를 가져올 수 있게끔 저장 되어있음
//   late GrowLanguage _translateLanguage;
//
//   /// 번역 이전의 ko,en 두 데이터를 모두 가지고 있음
//   late GrowTranslations growTranslations;
//
//   static bool get isKo => getLanguageType() == LanguageType.ko;
//   static bool get isEn => getLanguageType() == LanguageType.en;
//
//   /// 언어를 init 해주는 부분, 최초 1회 호출 및 개발자전용 화면에서 언어변경시 호출
//   Future<void> initLanguage() async {
//     growTranslations = await _setTranslations();
//     _translateLanguage = await _setLanguage();
//   }
//
//   /// 설정된 언어를 가져옴
//   Future<GrowLanguage> _setLanguage() async {
//     LanguageType type = getLanguageType();
//     if (type == LanguageType.en) {
//       return _translateLanguage = growTranslations.enEu;
//     } else {
//       return _translateLanguage = growTranslations.koKr;
//     }
//   }
//
//   /// main.dart에서 init 되는 [Languages] 클래스를 생성함
//   Future<GrowTranslations> _setTranslations() async {
//     return GrowTranslations(
//       koKr: await _modelFromPath('assets/json/translate_kr.json'),
//       enEu: await _modelFromPath('assets/json/translate_en.json'),
//     );
//   }
//
//   /// path로 부터 json을 가져와 모델로 파싱해주는 부분
//   Future<GrowLanguage> _modelFromPath(String path) async {
//     final jsonString = await rootBundle.loadString(path);
//     Map<String, dynamic> _jsonData = json.decode(jsonString);
//     return GrowLanguage.fromJson(_jsonData);
//   }
//
//   static LanguageType getLanguageType() {
//     LanguageType defaultType = LanguageType.ko;
//     var lang = GetStorage().read(Keys.LANGUAGE) ?? defaultType.text;
//     for (LanguageType type in LanguageType.values) {
//       if (type.enText == lang) {
//         return type;
//       }
//     }
//     return defaultType;
//   }
//
//   static Future<void> setLanguageType(LanguageType languageType) async {
//     GetStorage().write(Keys.LANGUAGE, languageType.enText);
//     await Get.updateLocale(languageType.locale);
//     TranslateHelper().initLanguage();
//   }
// }
//
// extension TrStringExtension on String {
//   /// trParams 대신 이거 사용
//   String params([Map<String, String> params = const {}]) {
//     var trans = this;
//     if (params.isNotEmpty) {
//       params.forEach((key, value) {
//         if (key == 'month') {
//           trans = trans.replaceAll('@month', getMonthName(value));
//         }
//         trans = trans.replaceAll('@$key', value);
//       });
//     }
//     return trans;
//   }
//
//   String getMonthName(String month) {
//     if (!TranslateHelper.isEn) return month;
//     switch (month) {
//       case '1':
//         return 'Jan';
//       case '2':
//         return 'Feb';
//       case '3':
//         return 'Mar';
//       case '4':
//         return 'Apr';
//       case '5':
//         return 'May';
//       case '6':
//         return 'Jun';
//       case '7':
//         return 'Jul';
//       case '8':
//         return 'Aug';
//       case '9':
//         return 'Sep';
//       case '10':
//         return 'Oct';
//       case '11':
//         return 'Nov';
//       case '12':
//         return 'Dec';
//       default:
//         return month;
//     }
//   }
// }
