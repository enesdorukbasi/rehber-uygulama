import 'dart:io';

import 'package:enes_dorukbasi/core/models/cities_model.dart';
import 'package:enes_dorukbasi/core/models/person_details_model.dart';
import 'package:enes_dorukbasi/core/models/persons_model.dart';

abstract class IPersonService {
  Future<dynamic> fetchAllPerson(
      {required int page,
      required String mail,
      required String password,
      int? cityId,
      int? genderId,
      String? personName});
  Future<CitiesModel?> fetchAllCities();
  Future<void> fetchAllDistrictByCityId(int cityId);
  Future<dynamic> fetchPersonDetails(
      {required String mail, required String password, required int personId});
  Future<dynamic> updateOrGeneratePerson(
      {required String mail,
      required String password,
      required int personId,
      required int cityId,
      required int townId,
      required String personName,
      required String personPhone,
      required int genderId,
      required File image});
  Future<bool> deletePerson(
      {required String mail, required String password, required int personId});
}
