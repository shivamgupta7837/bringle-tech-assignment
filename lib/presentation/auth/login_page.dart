import 'package:face_filter/presentation/auth/signup_page.dart';
import 'package:face_filter/presentation/home_page.dart';
import 'package:face_filter/services/share_pref/share_pref.dart';
import 'package:face_filter/utils/commons/common_widget/app_commons_widget.dart';
import 'package:face_filter/utils/themes/app_colors.dart';
import 'package:face_filter/utils/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> verifiedUser(userEmail, userPassword) async {
    final loginDetails = SharePreference.instance.loginDetails;
    print("Login details: $loginDetails");
    if (loginDetails != null) {
      if (loginDetails.email == userEmail &&
          loginDetails.password == userPassword) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Desktop and Tablet layout (logo on left, form on right)
            return _buildLargeScreenLayout(context);
          } else {
            // Mobile layout (stacked)
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        constraints: const BoxConstraints(maxWidth: 900),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 1,
              child: _buildForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/logo.jpg',
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
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
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
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
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: AppColors().primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (await verifiedUser(
                  _emailController.text,
                  _passwordController.text,
                )) {
                  SharePreference.instance.setUserIsLogin();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                } else {
                  AppCommonsWidgets().customSnackBar(
                    context,
                    "Wrong password or email",
                    null,
                  );
                }
              }
            },
            child: AppFonts().heading(
              "Login",
              fontColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpPage(),
                ),
              );
            },
            child: AppFonts().subHeading(
              "Don't have an account? Sign up!",
              fontColor: AppColors().fontColor,
            ),
          ),
        ],
      ),
    );
  }
}