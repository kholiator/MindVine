import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindvine/features/auth/view/login_view.dart';
import 'package:mindvine/features/auth/view/signup_view.dart';
import 'package:mindvine/theme/pallete.dart';

class LandingPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LandingPage(),
      );

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 100,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Connect your Mind with\n",
                          style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: ' MindVine',
                              style: GoogleFonts.pacifico(
                                  color: Pallete.blueColor,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            )
                          ])),
                ]),
            const SizedBox(height: 100),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpView()));
                        },
                        child: const SizedBox(
                            height: 60,
                            width: 110,
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Pallete.blueColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      child: const SizedBox(
                        height: 60,
                        width: 110,
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
