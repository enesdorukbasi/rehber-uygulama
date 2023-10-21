class CitiesModel {
  List<Iller>? iller;
  int? success;

  CitiesModel({this.iller, this.success});

  CitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['iller'] != null) {
      iller = <Iller>[];
      json['iller'].forEach((v) {
        iller!.add(Iller.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iller != null) {
      data['iller'] = iller!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class Iller {
  int? cityId;
  String? cityName;

  Iller({this.cityId, this.cityName});

  Iller.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    return data;
  }
}
