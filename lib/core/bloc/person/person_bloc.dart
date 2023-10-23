// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:enes_dorukbasi/core/models/person_details_model.dart';
import 'package:enes_dorukbasi/core/models/persons_model.dart';
import 'package:enes_dorukbasi/core/services/database/user_db_service.dart';
import 'package:enes_dorukbasi/core/services/person/person_service.dart';
import 'package:enes_dorukbasi/ui/auth/login_page.dart';
import 'package:enes_dorukbasi/ui_helpers/dialog_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonService _personService;
  PersonBloc(this._personService) : super(PersonInitializing()) {
    on<FetchAllPersonEvent>((event, emit) async {
      try {
        emit(PersonInitializing());
        Map<String, dynamic>? profile =
            await UserProfileServiceByDB().fetchData();
        if (profile != null) {
          dynamic response = await _personService.fetchAllPerson(
              page: event.page!,
              mail: profile["mail"],
              password: profile["password"],
              cityId: event.cityId,
              genderId: event.genderId,
              personName: event.personName);
          if (response != null) {
            if (response["basari"] == 1) {
              emit(PersonInitialized(PersonsModel.fromJson(response)));
            } else {
              emit(PersonInitializeError(response["mesaj"]));
            }
          } else {}
        } else {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } on SocketException {
        emit(const PersonInitializeError("Sunucu hatası."));
      } catch (ex) {
        await DialogWidget.faildDialog(event.context, ex.toString());
        emit(const PersonInitializeError("Bir sorun oluştu."));
      }
    });
    on<FetchPersonDetailsEvent>((event, emit) async {
      try {
        emit(PersonInitializing());
        Map<String, dynamic>? profile =
            await UserProfileServiceByDB().fetchData();

        if (profile != null) {
          var response = await _personService.fetchPersonDetails(
              mail: profile["mail"],
              password: profile["password"],
              personId: event.personId);

          if (response != null) {
            if (response["basari"] == 1) {
              emit(PersonDetailsInitialized(
                  PersonDetailsModel.fromJson(response)));
            } else {
              emit(PersonInitializeError(response["mesaj"]));
            }
          } else {
            emit(const PersonInitializeError("Bir sorun oluştu."));
          }
        } else {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } on SocketException {
        emit(const PersonInitializeError("Sunucu hatası."));
      } catch (ex) {
        emit(const PersonInitializeError("Bir sorun oluştu."));
      }
    });
    on<UpdateOrGeneratePersonEvent>((event, emit) async {
      try {
        emit(PersonInitializing());
        Map<String, dynamic>? profile =
            await UserProfileServiceByDB().fetchData();
        if (profile != null) {
          dynamic result = await _personService.updateOrGeneratePerson(
            mail: profile["mail"],
            password: profile["password"],
            personId: event.personId,
            cityId: event.cityId,
            townId: event.districtId,
            personName: event.personName,
            personPhone: event.personPhone,
            image: event.image,
            genderId: event.genderId,
          );
          if (result["basari"] == 1) {
            if (event.personId != 0) {
              event.personBloc
                  .add(FetchPersonDetailsEvent(event.personId, event.context));
            } else {
              event.personBloc.add(FetchAllPersonEvent(
                  context: event.context,
                  cityId: event.cityIdForFilter,
                  genderId: event.genderIdForFilter,
                  page: event.pageNumber,
                  personName: event.personNameForFilter));
            }
            Navigator.pop(event.context);
          } else {
            await DialogWidget.faildDialog(event.context, result["mesaj"]);
            emit(const PersonInitializeError("Bir sorun oluştu."));
          }
        } else {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } on SocketException {
        emit(const PersonInitializeError("Sunucu hatası."));
        await DialogWidget.faildDialog(
          event.context,
          "Sunucu hatası.",
        );
      } catch (ex) {
        await DialogWidget.faildDialog(event.context, "Bir sorun oluştu.");
        emit(const PersonInitializeError("Bir sorun oluştu."));
      }
    });
    on<DeletePersonEvent>((event, emit) async {
      try {
        emit(PersonInitializing());
        Map<String, dynamic>? profile =
            await UserProfileServiceByDB().fetchData();
        if (profile != null) {
          var response = await _personService.deletePerson(
              mail: profile["mail"],
              password: profile["password"],
              personId: event.personId);
          if (response) {
            event.personBloc.add(
              FetchAllPersonEvent(
                context: event.context,
                page: event.pageNumber,
                cityId: event.cityId,
                genderId: event.genderId,
                personName: event.personName,
              ),
            );
            Navigator.pop(event.context);
          } else {
            await DialogWidget.faildDialog(
              event.context,
              "Silme işlemi sırasında bir sorun ile karşılaşıldı.",
            );
          }
        } else {
          Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      } on SocketException {
        await DialogWidget.faildDialog(
          event.context,
          "Sunucu hatası.",
        );
      } catch (ex) {
        await DialogWidget.faildDialog(
          event.context,
          "Silme işlemi sırasında bir sorun ile karşılaşıldı.",
        );
      }
    });
  }
}
