class DistrictModel {
  int? basari;
  int? durum;
  List<Ilceler>? ilceler;

  DistrictModel({this.basari, this.durum, this.ilceler});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    basari = json['basari'];
    durum = json['durum'];
    if (json['ilceler'] != null) {
      ilceler = <Ilceler>[];
      json['ilceler'].forEach((v) {
        ilceler!.add(Ilceler.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['basari'] = basari;
    data['durum'] = durum;
    if (ilceler != null) {
      data['ilceler'] = ilceler!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ilceler {
  int? townId;
  int? cityId;
  String? townName;

  Ilceler({this.townId, this.cityId, this.townName});

  Ilceler.fromJson(Map<String, dynamic> json) {
    townId = json['town_id'];
    cityId = json['city_id'];
    townName = json['town_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['town_id'] = townId;
    data['city_id'] = cityId;
    data['town_name'] = townName;
    return data;
  }
}
