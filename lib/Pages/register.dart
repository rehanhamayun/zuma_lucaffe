import 'package:coffe_qr/Api/api.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {
  bool _passwordVisible = false;

  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: keyForm,
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.8,
                    top: size.height * 0.02),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              Image.asset('assets/lucaffeMoto.png',height: size.height*0.3,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: TextFormField(
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'Complete number';
                    } else {
                      return null;
                    }
                  },
                  controller: controllerNumber,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(fontSize: 20),
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
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: TextFormField(
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value!.length < 3) {
                      return 'Complete name';
                    } else {
                      return null;
                    }
                  },
                  controller: controllerName,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 20),
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
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5))),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
                      hintStyle: const TextStyle(fontSize: 20),
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
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: SizedBox(
                    height: size.height * 0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(185, 26, 25, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          if (keyForm.currentState!.validate()) {
                            WelcomeApi().registro(
                                controllerEmail.text,
                                controllerPassword.text,
                                controllerName.text,
                                controllerNumber.text,
                                'user',
                                context);
                          }
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: size.height * 0.025),
                        ))),
              ),
              SizedBox(
                height: size.height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
