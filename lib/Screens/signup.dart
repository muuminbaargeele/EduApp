import 'package:edu_app/Screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edu_app/Providers/connprovider.dart';
import 'package:edu_app/Screens/login.dart';
import 'package:edu_app/databases/services.dart';
import 'package:provider/provider.dart';

import '../Widgets/mytextfield.dart';
import '../Widgets/primarybutton.dart';
import '../const.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  String usernameError = "";
  TextEditingController usernameController = TextEditingController();
  String emailError = "";
  TextEditingController emailController = TextEditingController();
  String passwordError = "";
  TextEditingController passwordController = TextEditingController();
  late Box box;
  bool isLoading = false;
  bool eyeOn = false;

  validation(
    email,
    username,
    pass,
  ) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@gmail.com$');
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{4,16}$');
    final RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@!$%^&*()\-_=+{};:,<.>]{8,}$');

    setState(() {
      emailError = email.isEmpty
          ? "Please Enter a Email"
          : emailRegex.hasMatch(email)
              ? ""
              : "Invalid Email";
      usernameError = username.isEmpty
          ? "Please Enter a Username"
          : usernameRegex.hasMatch(username)
              ? ""
              : "Invalid Username";
      passwordError = pass.isEmpty
          ? "Please Enter a Password"
          : passwordRegex.hasMatch(pass)
              ? ""
              : "Password must be at least 8 characters and contain at least 1 uppercase letter lowercase letter and number";
    });
  }

  signUpValidation(username, email, password, context) async {
    validation(email, username, password);
    if (emailError.isEmpty && usernameError.isEmpty && passwordError.isEmpty) {
      isLoading = true;
      final response = await register(username, email, password);
      if (response["status"] == "success") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OtpPage(
                      userGmail: email,
                    )));
      } else if (response["message"] == "Email already exists") {
        setState(() {
          emailError = response["message"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"]),
            duration: const Duration(seconds: 1),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
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
                  "Sign Up",
                  style: GoogleFonts.openSans(
                      fontSize: sizes("height", 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]),
                ),
              ),
              Text(
                "Create account and write note",
                style: TextStyle(
                    fontSize: sizes("height", 16),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
              SizedBox(
                height: sizes("height", 16),
              ),
              Text(
                "Username",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[900]),
              ),
              MyTextField(
                errorName: usernameError,
                controller: usernameController,
                text: "Your Username",
                textInputType: TextInputType.emailAddress,
                padding: sizes("height", 10),
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
                btntext: "Sign Up",
                fontclr: Colors.white,
                color: primaryColor,
                width: double.infinity,
                textSize: sizes("height", 16),
                isLoading: isLoading,
                ontap: () {
                  if (connectivityProvider.isConnected) {
                    signUpValidation(usernameController.text,
                        emailController.text, passwordController.text, context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No Internet'),
                        duration: Duration(seconds: 1)));
                  }
                },
              ),
              SizedBox(
                height: sizes("height", 16),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account?",
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
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
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
