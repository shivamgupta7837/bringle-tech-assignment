import 'package:face_filter/presentation/screens/insta.dart';
import 'package:face_filter/services/share_pref/share_pref.dart';
import 'package:face_filter/utils/themes/app_colors.dart';
import 'package:face_filter/utils/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:face_filter/utils/commons/common_widget/app_commons_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title: AppFonts().appBarHeading("Home Page")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile Layout
            return _buildMobileLayout(context);
          } else if (constraints.maxWidth < 1200) {
            // Tablet Layout
            return _buildTabletLayout(context);
          } else {
            // Desktop Layout
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _commonWidgets(context),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _commonWidgets(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
      child: Center(
        child: SizedBox(
          width: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _commonWidgets(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _commonWidgets(context) {
    return [
      CircleAvatar(
        radius: 70,
        child: ClipOval(
          child: Image.asset(
            "assets/images/logo.jpg",
            fit: BoxFit.cover,
            width: 140,
            height: 140,
          ),
        ),
      ),
      const SizedBox(height: 20),
      InkWell(
        onTap: (){
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FaceFilterApp(),
            ),
          );
        },
        child: Card(
          
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                     Icon(Icons.person, color: AppColors().primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      "Name : ",
                      style: GoogleFonts.openSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        "${SharePreference.instance.loginDetails?.name ?? 'N/A'}",
                        style: GoogleFonts.openSans(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                     Icon(Icons.email, color: AppColors().primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      "Email : ",
                      style: GoogleFonts.openSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        "${SharePreference.instance.loginDetails?.email ?? 'N/A'}",
                        style: GoogleFonts.openSans(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

    ];
  }
}