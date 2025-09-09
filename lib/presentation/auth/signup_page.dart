
import 'package:face_filter/data/login_model/login_model.dart';
import 'package:face_filter/presentation/auth/login_page.dart';
import 'package:face_filter/utils/commons/common_widget/app_commons_widget.dart';
import 'package:face_filter/utils/themes/app_colors.dart';
import 'package:face_filter/utils/themes/app_fonts.dart';
import 'package:face_filter/viewmodel/cubits/cubit/login_view_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatelessWidget {
   SignUpPage({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppCommonsWidgets().customAppBar("Sign Up", context),
      body: BlocBuilder<SigninViewModelCubit, LoginViewModelState>(
        builder: (context, state) {
          if (state is LoginViewModelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoginViewModelError) {
            return Center(
              child: Text(state.message),
            );
          }
           if (state is LoginViewModelSuccess) {
            Navigator.pop(context);
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller:nameController ,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Name',
                      labelStyle: GoogleFonts.openSans(
                        color: AppColors().fontColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Email',
                      labelStyle: GoogleFonts.openSans(
                        color: AppColors().fontColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Please enter a password with at least 8 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Password',
                      labelStyle: GoogleFonts.openSans(
                        color: AppColors().fontColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      backgroundColor: AppColors().primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        context.read<SigninViewModelCubit>().signIn(LoginModel(name: nameController.text, email: emailController.text, password: passwordController.text), context);
                      }
                    },
                    child: AppFonts().heading(
                      "Sign up",
                      fontColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

