import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/firebase_methods.dart';
import '../screens/home.dart';
import '../screens/verify.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  bool isLoginPressed = false;

  _performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _firebaseMethods.signInWithGoogle().then((UserCredential userCredential) {
      _firebaseMethods.authenticateUser(userCredential).then((isNewUser) {
        if (isNewUser) {
          _firebaseMethods.addDataToDb(userCredential).then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return const Home();
              }),
            );
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return const Home();
            }),
          );
        }
        setState(() {
          isLoginPressed = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoginPressed)
              const Center(
                child: CircularProgressIndicator(),
              ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Firebase Authentication",
                    style: TextStyle(
                      fontSize: 50,
                      color: Color.fromARGB(255, 11, 11, 11),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.blue.withAlpha(200),
                    highlightColor: Colors.blue.withAlpha(130),
                    onTap: _performLogin,
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(40),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              fit: BoxFit.cover,
                            ),
                            const Expanded(
                              child: Text(
                                "Log in with Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: Colors.blue.withAlpha(200),
                    highlightColor: Colors.blue.withAlpha(130),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (builder) => const Verify()));
                    },
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(40),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.phone),
                            Expanded(
                              child: Text(
                                "Authenticate me",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
