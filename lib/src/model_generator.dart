import 'dart:collection';

import 'package:dart_style/dart_style.dart';
import 'package:gh_i18n/src/syntax.dart';
import 'package:json_ast/json_ast.dart' show parse, Settings, Node;
import 'helpers.dart';

class ModelGenerator {
  final String _rootClassName;
  List<ClassDefinition> allClasses = <ClassDefinition>[];
  final Map<String, String> sameClassMapping = HashMap<String, String>();

  ModelGenerator(this._rootClassName);

  void _generateClassDefinition(String className,
      dynamic jsonRawDynamicData, String path, Node? astNode) {
    if(jsonRawDynamicData is List){
      final node = navigateNode(astNode, '0');
      _generateClassDefinition(className, jsonRawDynamicData[0], path, node!);
      return;
    }

    final Map<dynamic, dynamic> jsonRawData = jsonRawDynamicData;
    final keys = jsonRawData.keys;
    ClassDefinition classDefinition = ClassDefinition(className);
    for (var key in keys) {
      TypeDefinition typeDef;
      final node = navigateNode(astNode, key);
      typeDef = TypeDefinition.fromDynamic(jsonRawData[key], node);
      if (typeDef.name == 'Class') {
        typeDef.name = camelCase(key);
      }
      if (typeDef.name == 'List' && typeDef.subtype == 'Null') {
      }
      if (typeDef.subtype != null && typeDef.subtype == 'Class') {
        typeDef.subtype = camelCase(key);
      }
      classDefinition.addField(key, typeDef);
    }
    final similarClass = allClasses.firstWhere((cd) => cd == classDefinition,
        orElse: () => ClassDefinition(""));
    if (similarClass.name != "") {
      final similarClassName = similarClass.name;
      final currentClassName = classDefinition.name;
      sameClassMapping[currentClassName] = similarClassName;
    } else {
      allClasses.add(classDefinition);
    }
    final dependencies = classDefinition.dependencies;
    for (var dependency in dependencies) {
      if (dependency.typeDef.name == 'List') {
        if (jsonRawData[dependency.name].length > 0) {
          dynamic toAnalyze;
          if (!dependency.typeDef.isAmbiguous) {
            WithWarning<Map> mergeWithWarning = mergeObjectList(
                jsonRawData[dependency.name], '$path/${dependency.name}');
            toAnalyze = mergeWithWarning.result;
          } else {
            toAnalyze = jsonRawData[dependency.name][0];
          }
          final node = navigateNode(astNode, dependency.name);
          _generateClassDefinition(dependency.className, toAnalyze,
              '$path/${dependency.name}', node);
        }
      } else {
        final node = navigateNode(astNode, dependency.name);
        _generateClassDefinition(dependency.className,
            jsonRawData[dependency.name], '$path/${dependency.name}', node);
      }
    }
  }

  /// json 파일 데이터를 가져와서 다트 코드로 바꿔주는 부분
  String generateUnsafeDart(String rawJson) {
    final jsonRawData = decodeJSON(rawJson);
    final astNode = parse(rawJson, Settings());
    _generateClassDefinition(_rootClassName, jsonRawData, "", astNode);
    for (var c in allClasses) {
      final fieldsKeys = c.fields.keys;
      for (var f in fieldsKeys) {
        final typeForField = c.fields[f];
        if (typeForField != null) {
          if (sameClassMapping.containsKey(typeForField.name)) {
            c.fields[f]!.name = sameClassMapping[typeForField.name]!;
          }
        }
      }
    }
    return allClasses.map((c) => c.toString()).join('\n');
  }

  /// [진입점] 코드를 받아와서 dart formatter를 통해 정리함
  String generateDartClasses(String rawJson) {
    final unsafeDartCode = generateUnsafeDart(rawJson);
    final formatter = DartFormatter();
    return formatter.format(unsafeDartCode);
  }
}