class GhI18nLanguage {
  Home? home;

  GhI18nLanguage({this.home});

  GhI18nLanguage.fromJson(Map<String, dynamic> json) {
    home = json['home'] != null ? Home.fromJson(json['home']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (home != null) {
      data['home'] = home!.toJson();
    }
    return data;
  }
}

class Home {
  String? count;
  String? btnText;
  String? text;

  Home({this.count, this.btnText, this.text});

  Home.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    btnText = json['btn_text'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['btn_text'] = btnText;
    data['text'] = text;
    return data;
  }
}
