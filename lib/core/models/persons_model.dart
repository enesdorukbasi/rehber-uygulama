class PersonsModel {
  Kisiler? kisiler;
  int? basari;
  int? durum;

  PersonsModel({this.kisiler, this.basari, this.durum});

  PersonsModel.fromJson(Map<String, dynamic> json) {
    kisiler =
        json['kisiler'] != null ? Kisiler.fromJson(json['kisiler']) : null;
    basari = json['basari'];
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kisiler != null) {
      data['kisiler'] = kisiler!.toJson();
    }
    data['basari'] = basari;
    data['durum'] = durum;
    return data;
  }
}

class Kisiler {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Kisiler(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Kisiler.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
  int? kisiId;
  String? kisiAd;
  String? kisiTel;
  String? resim;
  int? cinsiyet;
  int? cityId;
  int? townId;
  String? cityName;
  String? townName;

  Data(
      {this.kisiId,
      this.kisiAd,
      this.kisiTel,
      this.resim,
      this.cinsiyet,
      this.cityId,
      this.townId,
      this.cityName,
      this.townName});

  Data.fromJson(Map<String, dynamic> json) {
    kisiId = json['kisi_id'];
    kisiAd = json['kisi_ad'];
    kisiTel = json['kisi_tel'];
    resim = json['resim'];
    cinsiyet = json['cinsiyet'];
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
    data['resim'] = resim;
    data['cinsiyet'] = cinsiyet;
    data['city_id'] = cityId;
    data['town_id'] = townId;
    data['city_name'] = cityName;
    data['town_name'] = townName;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
