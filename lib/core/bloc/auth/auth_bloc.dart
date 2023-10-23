// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:enes_dorukbasi/core/services/auth/auth_service.dart';
import 'package:enes_dorukbasi/core/services/database/user_db_service.dart';
import 'package:enes_dorukbasi/ui_helpers/dialog_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService;
  AuthBloc(this.authService) : super(const AuthState.unknown()) {
    on<AppStarted>((event, emit) async {
      try {
        Map<String, dynamic>? data = await UserProfileServiceByDB().fetchData();
        if (data != null) {
          emit(const AuthState.authenticated());
        }
      } on SocketException {
        emit(AuthState.error(error: "Sunucu hatası."));
      } catch (e) {
        // add(LogOutRequested(event.context));
        if (kDebugMode) {
          print(e);
        }
        emit(AuthState.error());
      }
    });
    on<LoginEvent>((event, emit) async {
      try {
        dynamic response = await authService.login(
          email: event.email,
          password: event.password,
        );
        if (response != null) {
          if (response["basari"] == 1) {
            await UserProfileServiceByDB().insert(
              mail: event.email,
              password: event.password,
            );
            emit(const AuthState.authenticated());
          } else if (response["basari"] == 0) {
            DialogWidget.faildDialog(event.context, response["mesaj"]);
            emit(AuthState.error(error: response["mesaj"]));
          }
        } else {
          emit(AuthState.error(error: "Bir hata ile karşılaşıldı."));
        }
      } catch (ex) {
        if (kDebugMode) {
          print("hata :: $ex");
        }
        emit(AuthState.error(error: "Bir hata ile karşılaşıldı."));
      }
    });
  }
}
