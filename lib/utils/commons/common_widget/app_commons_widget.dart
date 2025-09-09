import 'package:flutter/material.dart';
import 'package:face_filter/utils/themes/app_colors.dart';
import 'package:face_filter/utils/themes/app_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCommonsWidgets {
  AppBar customAppBar(String heading,BuildContext context){
    return  AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),color: AppColors().fontColor,),
        title: AppFonts().appBarHeading(heading));
  }

  Container customContainer(Widget child,{double height=0.0 ,double width=0.0,Color bgColor = Colors.white}){
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: child,
    );
  }

 void customSnackBar(BuildContext context,   String message,
SnackBarAction? action
) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors().primaryColor,
          content: Text(
           message,
            style: GoogleFonts.openSans(color: Colors.black, fontSize: 16),
          ),
          action: action
        ),
      );
  }

}