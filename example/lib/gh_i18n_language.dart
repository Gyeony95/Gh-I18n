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

  Home({this.count, this.btnText});

  Home.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    btnText = json['btn_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['btn_text'] = btnText;
    return data;
  }
}
