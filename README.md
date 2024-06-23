# GH-I18n

This plugin is a plugin that helps you easily implement i18n functions in Flutter.  
이 플러그인은 플러터에서 i18n 기능을 쉽게 구현할 수 있게 도와주는 플러그인입니다.



## Getting Started

First you need to create a gh_i18n.yaml file in the root path of your project.  
먼저 프로젝트의 루트 경로에 gh_i18n.yaml 파일을 생성해야 합니다.


```yaml
# Path where you want to save json as model
classPath: "./lib/"
# name of json model
modelNm: "GhI18nLanguage"
# name of json file
fileNm: "gh_i18n_language"
# Location of json file
jsonPath: "./assets/"
# The name that becomes the base of the json file containing your multilingual information
jsonNm: "i18n_json"
```

There must be one json file for each language containing your multilingual information. For example, if your jsonNm is i18n_json and you support Korean and English, `i18n_json_kr.json` and `i18n_json_en.json` files must exist in the jsonPath path, respectively.   
다국어 정보가 포함된 각 언어마다 하나의 json 파일이 있어야 합니다. 예를 들어 jsonNm이 i18n_json이고 한국어와 영어를 지원하는 경우 jsonPath 경로에 `i18n_json_kr.json` 및 `i18n_json_en.json` 파일이 각각 존재해야 합니다.

Below is an example.  
아래에 그 예시가 있습니다.

`i18n_json_kr.json`
```json
{
  "home" : {
    "count": "@n개",
    "btn_text": "숫자 더하기",
    "text": "버튼을 눌러 숫자를 더해보세요"
  }
}
```

`i18n_json_en.json`
```json
{
  "home" : {
    "count": "Count @n",
    "btn_text": "Add Count",
    "text": "You have pushed the button this many times:"
  }
}
```

Then enter the following command in your project root path.  
그 다음엔 당신의 프로젝트 루트 경로에 아래와 같은 명령어를 입력합니다.

```
dar run gh_i18n
```

Then, the extracted model, `gh_i18n_translator.dart`, and `gh_i18n_helper.dart` files will be created with the file name you set.  
그러면 당신이 설정한 파일명으로 추출된 모델과 `gh_i18n_translator.dart`, `gh_i18n_helper.dart` 파일이 생성됩니다.

Up to this point, the basic preparation is complete and the multilingual module is initialized before the app is executed, as shown in the code below.  
여기까지 하면 밑준비는 끝났고 아래 코드와 같이 앱이 실행되기 전 다국어 모듈을 초기화 해줍니다.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GhTranslatorHelper().initLanguage();
  runApp(const MyApp());
}
```

You can then use the multilingual model converted to type safe code like the code below.
그리고 나서 아래 코드처럼 type safe 코드로 변환된 다국어 모델을 사용할 수 있습니다.

```dart
Text(
  tl.home?.text ?? '',
),
Text(
  tl.home?.count?.params({'n': '$_counter'}) ?? '',
  style: Theme.of(context).textTheme.headlineMedium,
),
```

## Insert variable

The params() function is provided as an extension function of String.  
String의 확장 함수로 params() 함수를 제공합니다. 

```json
{
  "home" : {
    "count": "Count @n"
  }
}
```
You can add variables marked with @ to the json file as shown in the code above, and you can enter values into the variables in map form in dart as shown in the code below.  
위 코드와 같이 @ 라는 표시가 붙은 변수를 json 파일에 추가할 수 있고 아래 코드와 같이 dart 에서 map 형태로 변수에 값을 넣을 수 있습니다.

```dart
Text(
  tl.home?.count?.params({'n': '$_counter'}) ?? ''
),
```