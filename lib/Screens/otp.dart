import 'package:edu_app/Databases/services.dart';
import 'package:edu_app/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/screens/home.dart';
import 'package:edu_app/widgets/errorcatch.dart';
import 'package:edu_app/widgets/otptextfield.dart';
import 'package:edu_app/widgets/primarybutton.dart';
import 'package:hive/hive.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.userGmail});
  final String userGmail;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = "";
  String otpError = "";
  bool isLoading = false;
  late Box box;

  otpValidate(gmail, otp, context) async {
    setState(() {
      otpError = otp.isEmpty ? "Please Enter OTP Code" : "";
    });

    if (otpError.isEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        final response = await otpCheck(gmail, otp);
        // Process the response data
        if (response["status"] == "success") {
          if (kDebugMode) {
            print(response["UserId"]);
          }
          String userId = response["UserId"].toString();
          box.put("UserId", userId);
          box.put("isLogin", true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false);
        } else {
          setState(() {
            otpError = response["message"];
          });
        }
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        // Handle login failure or error
        if (kDebugMode) {
          print('Login failed or error occurred. Error: $error');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('local_storage');
  }

  @override
  Widget build(BuildContext context) {
    final double v = MediaQuery.of(context).size.height;
    final double h = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: v * 0.196),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Verification Code",
              style: TextStyle(
                fontSize: v * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: v * 0.01152),
              child: Text(
                "Please type verification code send\nto ${widget.userGmail}",
                style: TextStyle(
                    fontSize: v * 0.0138,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: v * 0.075),
                  child: SizedBox(
                    width: h * 0.6447,
                    child: AdvancedOtpTextField(
                      onOtpEntered: (enteredOtp) {
                        if (kDebugMode) {
                          print("Code is $enteredOtp");
                        }
                        setState(() {
                          otp = enteredOtp;
                        });
                      },
                      error: otpError != "",
                    ),
                  ),
                ),
                ErrorCatch(errorName: otpError),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: v * 0.0461),
              child: PrimryButton(
                  btntext: "Verify",
                  fontclr: Colors.white,
                  color: primaryColor,
                  width: h * 0.6447,
                  isLoading: isLoading,
                  ontap: () {
                    FocusScope.of(context).unfocus();
                    otpValidate(widget.userGmail, otp, context);
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
