import 'package:flutter/material.dart';
import 'package:medigestion_admin/src/blocs/login_bloc.dart';
import 'package:medigestion_admin/src/blocs/user_bloc.dart';
export 'login_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final userBloc = new UserBloc();
  static Provider _instancia;
//Modelo Singleton
  factory Provider({Key key, Widget child}) {
    //Si la instancia no esta creada, se crea
    //caso contrario se regresa la misma
    if (_instancia == null) {
      _instancia = new Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  //Key= identificador unico del child
  //Provider({Key key, Widget child})
  //    :super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static UserBloc userBlocOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().userBloc;
  }
}
