import 'package:enes_dorukbasi/core/bloc/auth/auth_bloc.dart';
import 'package:enes_dorukbasi/core/bloc/person/person_bloc.dart';
import 'package:enes_dorukbasi/core/services/auth/auth_service.dart';
import 'package:enes_dorukbasi/core/services/person/person_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DependencyInjector {
  static DependencyInjector? _instance;

  static DependencyInjector get instance {
    _instance ??= DependencyInjector._init();
    return _instance!;
  }

  //Services
  late final AuthService _authService;
  late final PersonService _personService;

  //Blocs
  late final AuthBloc _authBloc;
  late final PersonBloc _personBloc;

  DependencyInjector._init() {
    _authService = AuthService();
    _personService = PersonService();

    _authBloc = AuthBloc(_authService);
    _personBloc = PersonBloc(_personService);
  }

  List<BlocProvider<Bloc>> get blocProviders => [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider<PersonBloc>(create: (context) => _personBloc),
      ];
}
