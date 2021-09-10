import 'package:flutter/material.dart';

import '../api/shared_preferences.dart';
import '../main.dart';
import '../resources/firebase_methods.dart';
import '../screens/verify.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Google_Contacts_icon.svg/2048px-Google_Contacts_icon.svg.png";
  String name = "";
  String email = "";
  String phoneNumber = "";
  bool emailVerified = false;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  @override
  void initState() {
    super.initState();
    _firebaseMethods.getCurrentUser().then((value) {
      if (value != null) {
        setState(() {
          if (value.phoneNumber != null) {
            phoneNumber = value.phoneNumber.toString();
            SharedPref.getUserDetails().then((userDetalis) {
              if (userDetalis.length > 2) {
                name = userDetalis[0];
                email = userDetalis[1];
                url = userDetalis[2];
              }
            });
          } else {
            name = value.displayName!;
            url = value.photoURL!;
            email = value.email!;
            emailVerified = value.emailVerified;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                _firebaseMethods.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (builder) => const MyApp()));
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                width: 150,
                height: 150,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.grey.withOpacity(0.4),
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.4),
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.4),
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.4),
                  ]),
                  shape: BoxShape.circle,
                ),
                duration: const Duration(seconds: 10),
                child: ClipOval(
                  child: Image.network(
                    url,
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    email.length > 5 ? email : "Email Not Authenticated",
                    style: const TextStyle(color: Colors.black),
                  ),
                  emailVerified || phoneNumber.length > 5 && email.length > 5
                      ? const Icon(
                          Icons.done,
                          color: Colors.greenAccent,
                        )
                      : const Icon(
                          Icons.clear,
                          color: Colors.redAccent,
                        )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    phoneNumber.length > 5 ? phoneNumber : "Not Authenticated",
                    style: const TextStyle(color: Colors.black),
                  ),
                  phoneNumber.length > 5
                      ? const Icon(
                          Icons.done,
                          color: Colors.greenAccent,
                        )
                      : const Icon(
                          Icons.clear,
                          color: Colors.redAccent,
                        )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  child: const Text("Authenticate"),
                  onPressed: () {
                    _firebaseMethods.signOut().then((value) {
                      SharedPref.setUserDetails(
                              name: name, email: email, url: url)
                          .then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => const Verify()));
                      });
                    });
                  }),
            ]),
      ),
    );
  }
}
