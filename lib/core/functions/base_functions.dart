import 'dart:core';
import 'dart:io';

import 'package:enes_dorukbasi/ui_helpers/dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseFunctions {
  static BaseFunctions? _instance;
  static BaseFunctions get instance {
    _instance ??= BaseFunctions._init();
    return _instance!;
  }

  final ValueNotifier<Locale?> _locale = ValueNotifier<Locale?>(null);

  BaseFunctions._init();
  ValueNotifier<Locale?> getNotifer() {
    return _locale;
  }

  Widget platformIndicator({Color color = Colors.blue}) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
              color: color,
            )
          : CircularProgressIndicator(
              color: color,
            ),
    );
  }

  callNumber(String phoneNumber, BuildContext context) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res == null || res == false) {
      final Uri smsLaunchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(Uri.parse("tel:$phoneNumber"));
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        // ignore: use_build_context_synchronously
        DialogWidget.faildDialog(
            context, "Bu işlem cihaz tarafından desteklenmiyor olabilir.");
      }
    }
  }

  messageNumber(String phoneNumber, BuildContext context) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': Uri.encodeComponent(''),
      },
    );
    if (await canLaunchUrl(smsLaunchUri)) {
      await launchUrl(smsLaunchUri);
    } else {
      // ignore: use_build_context_synchronously
      DialogWidget.faildDialog(context, "Şu an bu işlem gerçekleştirilemiyor.");
    }
  }

  emailValidateOperation(dynamic email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (email == null || email.isEmpty || !emailValid) {
      return "Geçerli bir e-posta adresi giriniz !";
    }
    return null;
  }

  String toShortDoubleNumber(double value) {
    String number = value.toString();
    return "${number.split(".").first}.${number.split(".")[1].substring(0, 2)}";
  }
}
