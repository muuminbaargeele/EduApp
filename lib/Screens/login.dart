import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Screens/home.dart';
import 'package:edu_app/Screens/signUp.dart';
import 'package:edu_app/Widgets/mytextfield.dart';
import 'package:edu_app/Widgets/primarybutton.dart';
import 'package:edu_app/Databases/services.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  sizes(type, size) {
    if (type == "width") {
      double converted = size / 183;
      return MediaQuery.of(context).size.width * converted;
    }
    if (type == "height") {
      double converted = size / 901;
      return MediaQuery.of(context).size.height * converted;
    }
  }

  String emailError = "";
  TextEditingController emailController = TextEditingController();
  String passwordError = "";
  TextEditingController passwordController = TextEditingController();
  late Box box;
  bool isLoading = false;
  bool eyeOn = true;

  loginValidation(email, password, context) async {
    setState(() {
      emailError = email.isEmpty ? "Please enter an Email" : "";
      passwordError = password.isEmpty ? "Please enter a Password" : "";
    });
    if (emailError.isEmpty && passwordError.isEmpty) {
      isLoading = true;
      final response = await login(email, password, box);
      if (response["Status"] == "Success") {
        String userId = response["UserId"];
        box.put("UserId", userId);
        box.put("isLogin", true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false);
      } else if (response["Status"] == "Incorrect email") {
        setState(() {
          emailError = response["Status"];
        });
      } else {
        setState(() {
          passwordError = response["Status"];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    box = Hive.box('local_storage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: sizes("height", 50)),
                child: Text(
                  "Welcome Back👋🏼",
                  style: GoogleFonts.openSans(
                      fontSize: sizes("height", 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]),
                ),
              ),
              Text(
                "Sign to your account",
                style: TextStyle(
                    fontSize: sizes("height", 16),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              SizedBox(
                height: sizes("height", 16),
              ),
              Text(
                "Email",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[900]),
              ),
              MyTextField(
                errorName: emailError,
                controller: emailController,
                text: "Your Email",
                textInputType: TextInputType.emailAddress,
                padding: sizes("height", 10),
              ),
              SizedBox(
                height: sizes("height", 16),
              ),
              Text(
                "Password",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[900]),
              ),
              MyTextField(
                errorName: passwordError,
                controller: passwordController,
                text: "Your Password",
                textInputType: TextInputType.visiblePassword,
                isPassword: true,
                eyeOn: eyeOn,
                eyeChange: () {
                  setState(() {
                    eyeOn = !eyeOn;
                  });
                },
                padding: sizes("height", 10),
              ),
              SizedBox(
                height: sizes("height", 40),
              ),
              PrimryButton(
                btntext: "Login",
                fontclr: Colors.white,
                color: primaryColor,
                width: double.infinity,
                isLoading: isLoading,
                textSize: sizes("height", 16),
                ontap: () {
                  if (connectivityProvider.isConnected) {
                    loginValidation(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No Internet'),
                        duration: Duration(seconds: 1)));
                  }
                },
              ),
              SizedBox(
                height: sizes("height", 20),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.grey, fontSize: sizes("height", 12)),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: sizes("height", 12)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
