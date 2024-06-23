import 'dart:io';

import 'package:gh_i18n/src/model_generator.dart';
import "package:path/path.dart" show join, normalize;
import 'package:yaml/yaml.dart';

class GhParser {

  late String classPath;
  late String modelNm;
  late String fileNm;
  late String jsonPath;
  late String jsonNm;

  void startParse() {
    var config = loadYaml(File('gh_i18n.yaml').readAsStringSync());

    if (config.isEmpty) {
      _alertMessage();
      return;
    }
    print(config);
    classPath = config['classPath']; // ./lib/src/
    modelNm = config['modelNm']; // GhI18nLanguage
    fileNm = config['fileNm']; // gh_i18n_language
    jsonPath = config['jsonPath']; // ./bin/
    jsonNm = config['jsonNm']; // sample
    _createJsonFile();
    _createTranslatorFile();
    _createHelperFile();
  }

  void _createJsonFile(){
    final filePath = normalize(join(jsonPath, '$jsonNm'+'_en'+'.json'));
    final jsonRawData = File(filePath).readAsStringSync();
    final classGenerator = ModelGenerator(modelNm);
    String dartCode = classGenerator.generateDartClasses(jsonRawData);

    final newFilePath = join(classPath, '$fileNm.dart');
    // json 파일 생성
    _makeNewFile(path: newFilePath, code: dartCode);
  }

  void _createTranslatorFile(){
    String code = _getTranslatorString();
    final newFilePath = join(classPath, 'gh_i18n_translator.dart');
    _makeNewFile(path: newFilePath, code: code);
  }

  void _createHelperFile(){
    String code = _getHelperString();
    final newFilePath = join(classPath, 'gh_i18n_helper.dart');
    _makeNewFile(path: newFilePath, code: code);
  }

  void _makeNewFile({
    required String path,
    required String code,
  }) {
    final newFile = File(path);
    newFile.writeAsStringSync(code);
  }

  String _getTranslatorString() {
    return
      '''
import '$fileNm.dart';

/// This class is created by the gh_i18n plugin.
class GhI18nTranslations {
  final $modelNm koKr;
  final $modelNm enEu;

  GhI18nTranslations({
    required this.koKr,
    required this.enEu,
  });
}
    ''';
  }

  String _getHelperString(){
    return '''
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gh_i18n/language_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '$fileNm.dart';
import 'gh_i18n_translator.dart';

/// 전역에서 사용될 수 있게 class 밖에 선언
/// Declared outside the class so that it can be used globally
GhI18nLanguage get tl => GhTranslatorHelper()._translateLanguage;

/// This class is created by the gh_i18n plugin.
class GhTranslatorHelper {
  static GhTranslatorHelper? _instance;

  GhTranslatorHelper._() {
    _instance ??= this;
  }

  factory GhTranslatorHelper() {
    return _instance ??= GhTranslatorHelper._();
  }

  /// key를 통해 번역된 언어를 가져올 수 있게끔 저장 되어있음
  late $modelNm _translateLanguage;

  /// 번역 이전의 ko,en 두 데이터를 모두 가지고 있음
  late GhI18nTranslations ghTranslations;

  static Future<bool> get isKo async => await getLanguageType() == LanguageType.ko;
  static Future<bool> get isEn async => await getLanguageType() == LanguageType.en;

  static const String _keyString = 'GH_I18N_KEY';

  /// 언어를 init 해주는 부분, 최초 1회 호출 및 개발자전용 화면에서 언어변경시 호출
  Future<void> initLanguage() async {
    ghTranslations = await _setTranslations();
    _translateLanguage = await _setLanguage();
  }

  /// 설정된 언어를 가져옴
  Future<GhI18nLanguage> _setLanguage() async {
    LanguageType type = await getLanguageType();
    if (type == LanguageType.en) {
      return _translateLanguage = ghTranslations.enEu;
    } else {
      return _translateLanguage = ghTranslations.koKr;
    }
  }

  /// main.dart에서 init 되는 [Languages] 클래스를 생성함
  Future<GhI18nTranslations> _setTranslations() async {
    return GhI18nTranslations(
      koKr: await _modelFromPath('$jsonPath$jsonNm'+'_kr.json'),
      enEu: await _modelFromPath('$jsonPath$jsonNm'+'_en.json'),
    );
  }

  /// path로 부터 json을 가져와 모델로 파싱해주는 부분
  Future<GhI18nLanguage> _modelFromPath(String path) async {
    final jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> _jsonData = json.decode(jsonString);
    return $modelNm.fromJson(_jsonData);
  }

  static Future<LanguageType> getLanguageType() async {
    LanguageType defaultType = LanguageType.ko;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString(_keyString) ?? '';
    for (LanguageType type in LanguageType.values) {
      if (type.text == lang) {
        return type;
      }
    }
    return defaultType;
  }

  static Future<void> setLanguageType(LanguageType languageType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyString, languageType.text);
    GhTranslatorHelper().initLanguage();
  }
}

extension TrStringExtension on String {
  /// trParams 대신 이거 사용
  String params([Map<String, String> params = const {}]) {
    var trans = this;
    if (params.isNotEmpty) {
      params.forEach((key, value) {
        trans = trans.replaceAll('@\$key', value);
      });
    }
    return trans;
  }
}
    ''';
  }

}

void _alertMessage() {
  print('경로가 올바르지 않습니다.');
  print('please enter correct info like next line');
  print('dart run gh_i18n <classPath> <modelNm> <fileNm> <jsonPath> <jsonNm>');
  print('''
  [required] classPath - 만들어질 dart 모델의 (절대/상대)경로
  [required] modelNm - 만들어질 모델의 이름 (ex. class ExampleModel {})
  [required] fileNm - dart 파일의 이름
  [required] jsonPath - model로 만들고자 하는 json 파일의 (절대/상대)경로
  [required] jsonNm - model로 만들고자 하는 json 파일의 이름
  ''');
}
