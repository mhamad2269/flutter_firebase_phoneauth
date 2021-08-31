import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../resources/firebase_methods.dart';
import 'home.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  final _mobController = TextEditingController();
  final _otpController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  final BoxDecoration _pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(235, 236, 237, 1),
    borderRadius: BorderRadius.circular(5.0),
  );

  String verifyId = "";
  String smsCode = "";

  bool isButton = false;
  bool _isOtpSent = false;
  bool _isLoading = false;

  Future sendOtp({required String mob}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: mob,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Fluttertoast.showToast(msg: "Otp Sent");
        setState(() {
          _isOtpSent = true;
          verifyId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Firebase Phone Auth",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_mobController.text.length >= 10 && _isOtpSent)
                Container(
                  margin: const EdgeInsets.all(40.0),
                  child: Text(
                    "+91 ${_mobController.text}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              _isOtpSent
                  ? PinPut(
                      withCursor: true,
                      fieldsCount: 6,
                      onChanged: (val) {
                        setState(() {
                          if (val.length > 5) {
                            isButton = true;
                          } else {
                            isButton = false;
                          }
                        });
                      },
                      autofocus: _isOtpSent,
                      fieldsAlignment: MainAxisAlignment.spaceAround,
                      textStyle:
                          const TextStyle(fontSize: 25.0, color: Colors.black),
                      eachFieldMargin: EdgeInsets.all(0),
                      eachFieldWidth: 45.0,
                      eachFieldHeight: 55.0,
                      focusNode: _pinPutFocusNode,
                      controller: _otpController,
                      submittedFieldDecoration: _pinPutDecoration,
                      selectedFieldDecoration: _pinPutDecoration.copyWith(
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      followingFieldDecoration: _pinPutDecoration,
                      pinAnimationType: PinAnimationType.scale,
                    )
                  : TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Enter Mobile Number",
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0)),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          prefix: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("+91 "),
                          )),
                      autofocus: true,
                      controller: _mobController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      style: const TextStyle(fontSize: 25),
                      onChanged: (val) {
                        setState(() {
                          if (val.length > 9) {
                            isButton = true;
                          } else {
                            isButton = false;
                          }
                        });
                      },
                    ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: isButton
                    ? _isOtpSent
                        ? () {
                            setState(() {
                              _isLoading = true;
                            });
                            _firebaseMethods
                                .verifyOtp(
                                    smsCode: _otpController.text,
                                    verificationId: verifyId)
                                .then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => Home()));
                            });
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        : () {
                            setState(() {
                              _isLoading = true;
                            });
                            final mobile = _mobController.text;

                            sendOtp(
                                    mob:
                                        "+91 ${mobile.substring(0, 5)} ${mobile.substring(5, 10)}")
                                .then((value) {
                              isButton = false;
                            });
                            setState(() {
                              _isLoading = false;
                            });
                          }
                    : null,
                style: ButtonStyle(
                  padding: !_isLoading
                      ? MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5))
                      : MaterialStateProperty.all(EdgeInsets.all(25)),
                  backgroundColor: isButton
                      ? MaterialStateProperty.all(
                          Colors.lightBlue,
                        )
                      : MaterialStateProperty.all(
                          Color.fromARGB(125, 225, 225, 225),
                        ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        _isOtpSent ? "Verify OTP" : "Send OTP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
