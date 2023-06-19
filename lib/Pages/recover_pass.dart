import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecuperarCorreo extends StatefulWidget {
  RecuperarCorreo({Key? key}) : super(key: key);
  @override
  State<RecuperarCorreo> createState() => _RecuperarCorreoState();
}

class _RecuperarCorreoState extends State<RecuperarCorreo> {
  TextEditingController controllerEmail = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          top: size.height * 0.05,
          left: size.width * 0.02,
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        Positioned(
          top: size.height * 0.3,
          left: size.width * 0.1,
          right: size.width * 0.1,
          child: Column(
            children: [
              Text(
                'Enter your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.height * 0.035,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    height: 1),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: keyForm,
                child: Column(
                  children: [
                    SizedBox(
                      //height: 50,
                      width: size.width * 0.8,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = RegExp(pattern);
                          if (value!.isEmpty) {
                            return "mail is necessary";
                          } else if (!regExp.hasMatch(value)) {
                            return "Invalid email";
                          } else {
                            return null;
                          }
                        },
                        controller: controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Mail',
                            hintStyle: TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Color.fromARGB(255, 233, 232, 232),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.5))),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    SizedBox(
                        height: size.height * 0.06,
                        width: size.width * 0.8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(185, 26, 25, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            if (keyForm.currentState!.validate()) {
                              FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: controllerEmail.text);
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      title: 'successful recovery',
                                      desc:
                                          "Check your email to finish the process\n(If you don't see our email, check your Spam folder)",
                                      btnOkOnPress: () {})
                                  .show();
                            }
                          },
                          child: Text('Next',style: TextStyle(fontSize: size.height*0.025),),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
