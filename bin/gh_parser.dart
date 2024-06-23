
import 'dart:io';

import 'package:gh_i18n/src/model_generator.dart';
import "package:path/path.dart" show join, normalize;
import 'package:yaml/yaml.dart';


class GhParser {
  void startParse(){
    var config = loadYaml(File('gh_i18n.yaml').readAsStringSync());

    if (config.isEmpty) {
      _alertMessage();
      return;
    }
    print(config);
    final createClassPath = config['classPath']; // ./lib/src/
    final createModelNm = config['modelNm']; // GhI18nLanguage
    final createClassNm = config['fileNm']; // grow_language
    final jsonPath = config['jsonPath']; // ./bin/
    final jsonNm = config['jsonNm']; // sample


    final classGenerator = ModelGenerator(createModelNm);
    final filePath = normalize(join(jsonPath, '$jsonNm.json'));
    final jsonRawData = File(filePath).readAsStringSync();
    String dartCode = classGenerator.generateDartClasses(jsonRawData);

    final newFilePath = join(createClassPath, '$createClassNm.dart');
    final newFile = File(newFilePath);
    newFile.writeAsStringSync(dartCode);
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
