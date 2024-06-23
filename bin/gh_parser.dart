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
    fileNm = config['fileNm']; // grow_language
    jsonPath = config['jsonPath']; // ./bin/
    jsonNm = config['jsonNm']; // sample
    _createJsonFile();
    _createTranslatorFile();

  }

  void _createJsonFile(){
    final filePath = normalize(join(jsonPath, '$jsonNm.json'));
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

class GhI18nTranslations {
  final GhI18nLanguage koKr;
  final GhI18nLanguage enEu;

  GhI18nTranslations({
    required this.koKr,
    required this.enEu,
  });
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
