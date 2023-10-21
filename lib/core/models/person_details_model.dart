class PersonDetailsModel {
  Kisi? kisi;
  int? basari;
  int? durum;

  PersonDetailsModel({this.kisi, this.basari, this.durum});

  PersonDetailsModel.fromJson(Map<String, dynamic> json) {
    kisi = json['kisi'] != null ? Kisi.fromJson(json['kisi']) : null;
    basari = json['basari'];
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kisi != null) {
      data['kisi'] = kisi!.toJson();
    }
    data['basari'] = basari;
    data['durum'] = durum;
    return data;
  }
}

class Kisi {
  int? kisiId;
  String? kisiAd;
  String? kisiTel;
  int? cinsiyet;
  String? resim;
  int? cityId;
  int? townId;
  String? cityName;
  String? townName;

  Kisi(
      {this.kisiId,
      this.kisiAd,
      this.kisiTel,
      this.cinsiyet,
      this.resim,
      this.cityId,
      this.townId,
      this.cityName,
      this.townName});

  Kisi.fromJson(Map<String, dynamic> json) {
    kisiId = json['kisi_id'];
    kisiAd = json['kisi_ad'];
    kisiTel = json['kisi_tel'];
    cinsiyet = json['cinsiyet'];
    resim = json['resim'];
    cityId = json['city_id'];
    townId = json['town_id'];
    cityName = json['city_name'];
    townName = json['town_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kisi_id'] = kisiId;
    data['kisi_ad'] = kisiAd;
    data['kisi_tel'] = kisiTel;
    data['cinsiyet'] = cinsiyet;
    data['resim'] = resim;
    data['city_id'] = cityId;
    data['town_id'] = townId;
    data['city_name'] = cityName;
    data['town_name'] = townName;
    return data;
  }
}
