import 'package:face_filter/utils/commons/common_widget/app_commons_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  
  Future<void> requestCameraPermission(BuildContext context) async {
    var status = await Permission.camera.request(); // PHONE permission
    var galleryStatus = await Permission.storage.request(); // PHONE permission
    if (status.isGranted || galleryStatus.isGranted) {
      print("Permission granted");
    } else if (status.isPermanentlyDenied) {
        AppCommonsWidgets().customSnackBar(context, "Permission denied. Please allow permission to use this feature.", SnackBarAction(
            label: 'Go to settings',
            onPressed: () async {
              await openAppSettings();
            },
          ),);

    } else if (status.isDenied|| galleryStatus.isDenied) {
      AppCommonsWidgets().customSnackBar(context, "Permission denied. Please allow permission to use this feature.",SnackBarAction(
            label: 'Retry',
            onPressed: () async{
              await Permission.camera.request();
            },
          ),);
    } else {
      print("Permission denied");
    }
  }
}
