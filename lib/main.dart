
import 'package:face_filter/presentation/auth/login_page.dart';
import 'package:face_filter/presentation/screens/insta.dart';
import 'package:face_filter/presentation/screens/splash_screen.dart';
import 'package:face_filter/services/share_pref/share_pref.dart';
import 'package:face_filter/utils/themes/app_colors.dart';
import 'package:face_filter/viewmodel/cubits/cubit/login_view_model_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharePreference.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => SigninViewModelCubit()),
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors().primaryColor ),
      ),
      home: SplashScreen()
    ));
  }
}