import 'package:flutter/material.dart';
import 'package:face_filter/utils/themes/app_fonts.dart';

class AppCommons {
  AppBar customAppBar(String heading){
    return  AppBar(
        automaticallyImplyLeading: true,
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
}