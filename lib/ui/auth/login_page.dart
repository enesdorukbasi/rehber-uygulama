import 'dart:async';

import 'package:enes_dorukbasi/core/bloc/auth/auth_bloc.dart';
import 'package:enes_dorukbasi/core/functions/base_functions.dart';
import 'package:enes_dorukbasi/init/extensions/num_extensions.dart';
import 'package:enes_dorukbasi/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureTextVal = true;
  Offset clickedOffset = const Offset(2, 2);

  late final AuthBloc _authBloc;
  late final StreamSubscription _authStream;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>()..add(AppStarted(context));
    _authStream = _authBloc.stream.listen((event) async {
      if (event.status == AuthStatus.authenticated) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              width: 90.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Giriş Ekranı",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: .5,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                  2.h.ph,
                  TextField(
                    controller: mailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Mail",
                    ),
                  ),
                  1.h.ph,
                  TextField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon:
                            Icon(isObscure ? Icons.remove_red_eye : Icons.lock),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: "Parola",
                    ),
                  ),
                  1.h.ph,
                  InkWell(
                    onTap: () {
                      if (mailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        clickedOffset = const Offset(0, 0);
                      });
                      _authBloc.add(
                        LoginEvent(
                          mailController.text,
                          passwordController.text,
                          context,
                        ),
                      );
                      Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          setState(() {
                            clickedOffset = const Offset(2, 2);
                          });
                        },
                      );
                    },
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: .5,
                            offset: clickedOffset,
                          )
                        ],
                      ),
                      child: Center(
                        child: (state.status == AuthStatus.authenticating)
                            ? BaseFunctions.instance.platformIndicator()
                            : Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: .5,
                                      offset: clickedOffset,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
