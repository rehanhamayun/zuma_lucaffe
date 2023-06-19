import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MemberShip extends StatefulWidget {
  MemberShip({Key? key}) : super(key: key);

  @override
  State<MemberShip> createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  TextEditingController controllerGold = TextEditingController();
  TextEditingController controllerPlatinum = TextEditingController();
  bool cargando = true;
  GlobalKey<FormState> keyForm = GlobalKey();
  getValues() async {
    await FirebaseFirestore.instance
        .collection('Data')
        .doc('MemberShip')
        .get()
        .then((value) {
      setState(() {
        controllerGold = TextEditingController(text: value['Gold'].toString());
        controllerPlatinum =
            TextEditingController(text: value['Platinum'].toString());
        cargando = false;
      });
    });
  }

  @override
  void initState() {
    getValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: keyForm,
        child: Center(
          child: cargando
              ? const CircularProgressIndicator()
              : ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: size.width * 0.8,
                          bottom: size.height * 0.05,
                          top: size.height * 0.05),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new)),
                    ),
                    Center(
                      child: Text(
                        'Membership Points\nLucaffe Egypt',
                        style: TextStyle(
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Complete number';
                          } else if(int.parse(controllerPlatinum.text) <= int.parse(value)){
                            return 'Gold cannot be higher than Platinum';
                          }else {
                            return null;
                          }
                        },
                        controller: controllerGold,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Gold number',
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
                      height: size.height * 0.02,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Complete number';
                          }else if(int.parse(controllerGold.text) >= int.parse(value)){
                            return 'Platinum cannot be less than Gold';
                          } else {
                            return null;
                          }
                        },
                        controller: controllerPlatinum,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Platinum number',
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      child: SizedBox(
                          height: size.height * 0.06,
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
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text('Loading'),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        );
                                      });
                                  FirebaseFirestore.instance
                                      .collection('Data')
                                      .doc('MemberShip')
                                      .update({
                                    'Gold': int.parse(controllerGold.text),
                                    'Platinum':
                                        int.parse(controllerPlatinum.text),
                                  }).then((value) {
                                    Navigator.pop(context);
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      title: 'Changes made successfully',
                                      // desc:
                                      //     'You have exceeded the limit of attempts, please come back later',
                                      btnOkOnPress: () {},
                                    ).show();
                                  });
                                }
                              },
                              child: const Text('Guardar'))),
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
