import 'dart:convert';
import 'dart:io';

import 'package:enes_dorukbasi/core/services/auth/i_auth_service.dart';
import 'package:enes_dorukbasi/init/network/dio_manager.dart';
import 'package:html_unescape/html_unescape.dart';

class AuthService extends IAuthService {
  @override
  Future<dynamic?> login(
      {required String email, required String password}) async {
    var response = await DioManager.instance.dio.post(
      "oturum-test",
      queryParameters: {
        "email": email,
        "sifre": password,
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return null;
    }
  }
}
