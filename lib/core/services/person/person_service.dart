import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enes_dorukbasi/core/models/cities_model.dart';
import 'package:enes_dorukbasi/core/models/person_details_model.dart';
import 'package:enes_dorukbasi/core/services/person/i_person_service.dart';
import 'package:enes_dorukbasi/init/network/dio_manager.dart';

class PersonService extends IPersonService {
  @override
  Future<CitiesModel?> fetchAllCities() async {
    var response = await DioManager.instance.dio.get("iller");

    if (response.data["success"] == 1) {
      return CitiesModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<void> fetchAllDistrictByCityId(int cityId) async {
    var response = await DioManager.instance.dio.post(
      "ilceler",
      queryParameters: {
        "city_id": cityId,
      },
    );

    if (response.data["success"] == 1) {
      return null;
    } else {
      return null;
    }
  }

  @override
  Future<dynamic> fetchAllPerson(
      {required int page,
      required String mail,
      required String password,
      int? cityId,
      int? genderId,
      String? personName}) async {
    var response = await DioManager.instance.dio.post(
      "kisiler",
      queryParameters: {
        "email": mail,
        "sifre": password,
        "page": page,
        "city_id": cityId,
        "cinsiyet": genderId,
        "kisi_ad": personName,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Future<dynamic> fetchPersonDetails(
      {required String mail,
      required String password,
      required int personId}) async {
    var response =
        await DioManager.instance.dio.post("kisi-goster", queryParameters: {
      "email": mail,
      "sifre": password,
      "kisi_id": personId,
    });

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Future<bool> deletePerson(
      {required String mail,
      required String password,
      required int personId}) async {
    var response = await DioManager.instance.dio.post(
      "kisi-sil",
      queryParameters: {
        "email": mail,
        "sifre": password,
        "kisi_id": personId,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      if (response.data["basari"] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<dynamic> updateOrGeneratePerson(
      {required String mail,
      required String password,
      required int personId,
      required int cityId,
      required int townId,
      required String personName,
      required String personPhone,
      required int genderId,
      required File? image}) async {
    var response = await DioManager.instance.dio.post(
      "kisi-kaydet",
      queryParameters: {
        "email": mail,
        "sifre": password,
        "kisi_id": personId,
        "city_id": cityId,
        "town_id": townId,
        "kisi_ad": personName,
        "kisi_tel": personPhone,
        "cinsiyet": genderId,
      },
      data: FormData.fromMap(
        {
          "resim":
              image != null ? await MultipartFile.fromFile(image.path) : null,
        },
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return null;
    }
  }
}
