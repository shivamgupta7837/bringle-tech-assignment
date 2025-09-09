import 'package:bloc/bloc.dart';
import 'package:face_filter/data/login_model/login_model.dart';
import 'package:face_filter/services/share_pref/share_pref.dart';
import 'package:face_filter/utils/commons/common_widget/app_commons_widget.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_view_model_state.dart';

class SigninViewModelCubit extends Cubit<LoginViewModelState> {
  SigninViewModelCubit() : super(LoginViewModelInitial());

  Future<void> signIn(LoginModel loginResponse,BuildContext context) async{
    emit(LoginViewModelLoading());
    try {
      final result = await SharePreference.instance.saveUserCredentials(loginModel: loginResponse);
    if(result){
      emit(LoginViewModelSuccess());
      AppCommonsWidgets().customSnackBar(context, "Data Saved Sucessfully", null);
    }else{
       AppCommonsWidgets().customSnackBar(context, "Sign up Failed", null);
        throw Exception("Sign up Failed");
    }
    } on Exception catch (e) {
      emit(LoginViewModelError(message:  e.toString()));
    }
  }
}
