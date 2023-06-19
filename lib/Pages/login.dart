import 'package:coffe_qr/Api/api.dart';
import 'package:coffe_qr/Pages/recover_pass.dart';
import 'package:coffe_qr/Pages/register.dart';
import 'package:flutter/material.dart';

import 'admin/admin.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerPassword = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        body: Form(
          key: keyForm,
          child: ListView(
            children: [
              Image.asset(
                'assets/lucaffeSolo.png',
                height: size.height * 0.35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: SizedBox(
                  height: size.height*0.06,
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
                        hintStyle: TextStyle(fontSize: 17),
                        filled: true,
                        fillColor: Color.fromARGB(255, 233, 232, 232),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5))),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: SizedBox(
                  height: size.height*0.06,
                  child: TextFormField(
                    controller: controllerPassword,
                    validator: (value) {
                      if (value!.length < 7) {
                        return 'Enter at least 7 characters';
                      } else {
                        return null;
                      }
                    },
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontSize: 17),
                        suffixIcon: IconButton(
                            onPressed: (() {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            )),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 233, 232, 232),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5))),
                    style: Theme.of(context).textTheme.headline6,
                    //keyboardType: TextInputType.name,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.38),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecuperarCorreo()));
                  },
                  child: Text(
                    'Recover Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: size.height * 0.023,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        height: 1),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                child: SizedBox(
                    height: size.height * 0.05,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(185, 26, 25, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          if (keyForm.currentState!.validate()) {
                            
                              WelcomeApi().iniciarSesion(controllerEmail.text,
                                  controllerPassword.text, context, 'mail');
                            
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: size.height * 0.025),
                        ))),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Center(
                child: Text(
                  'Or',
                  style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async{await WelcomeApi().iniciarSesion('', '', context, 'gmail');},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/gmail.jpg'),fit: BoxFit.cover,)
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async{
                      await WelcomeApi().signInWithTwitter();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/tw.jpg'),fit: BoxFit.cover)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.15),
                child: Container(
                  height: 2,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    'or Register',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
