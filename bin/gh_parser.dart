
import 'dart:io';

import 'package:gh_i18n/src/model_generator.dart';
import "package:path/path.dart" show join, normalize;

void main(List<String> arguments){
  if (arguments.isEmpty || arguments.length < 5) {
    _alertMessage();
    return;
  }
  print(arguments);
  final createClassPath = arguments[0]; // ./lib/src/
  final createModelNm = arguments[1]; // GhI18nLanguage
  final createClassNm = arguments[2]; // grow_language
  final jsonPath = arguments[3]; // ./bin/
  final jsonNm = arguments[4]; // sample


  final classGenerator = ModelGenerator(createModelNm);
  final filePath = normalize(join(jsonPath, '$jsonNm.json'));
  final jsonRawData = File(filePath).readAsStringSync();
  String dartCode = classGenerator.generateDartClasses(jsonRawData);

  final newFilePath = join(createClassPath, '$createClassNm.dart');
  final newFile = File(newFilePath);
  newFile.writeAsStringSync(dartCode);
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
