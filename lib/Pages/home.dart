import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_qr/Api/api.dart';
import 'package:coffe_qr/Pages/admin/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr/src/qr_image.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.type}) : super(key: key);
  String type;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = FirebaseAuth.instance.currentUser!;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController pointsController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  Barcode? result;
  QRViewController? controller;
  bool isShow = false;
  bool isRead = false;
  bool isFirst = true;
  bool isGivePoint = true;
  bool cargando = true;
  double points = 0;
  double toGivepoints = 0;
  int goldPoints = 0;
  int platinumPoints = 0;
  @override
  void initState() {
    super.initState();
    getValues();
  }

  getValues() async {
    await FirebaseFirestore.instance
        .collection('Data')
        .doc('MemberShip')
        .get()
        .then((value) {
      setState(() {
        goldPoints = value['Gold'];
        platinumPoints = value['Platinum'];
      });
      updateUser();
    });
  }

  updateUser() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get()
        .then((value) {
      !value.exists
          ? FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
              'nombre': user.displayName ?? '',
              'correo': user.email,
              'numero': null,
              'points': 0,
              'historialPoints': 0,
              'user': 'user',
              'uid': user.uid,
            }).then((value) => setState(() {
                cargando = false;
              }))
          : setState(
              () {
                cargando = false;
              },
            );
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(185, 26, 25, 1),
        title: Text(
          'Lucaffe Egypt',
          style: TextStyle(fontSize: size.height * 0.025),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                WelcomeApi().cerrarSesion();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : widget.type == 'user'
              ? _user(size)
              : _employee(size),
    );
  }

  StreamBuilder _user(Size size) {
    String memberShipType = 'Red';
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          memberShipType =
              snapshot.data!.docs[0]['historialPoints'] < goldPoints
                  ? 'Red'
                  : snapshot.data!.docs[0]['historialPoints'] < platinumPoints
                      ? 'Gold'
                      : 'Platinum';
          if (isFirst) {
            points = double.parse(snapshot.data!.docs[0]['points'].toString());
            isFirst = false;
          }
          if (points < snapshot.data!.docs[0]['points']) {
            Future.delayed(
                const Duration(milliseconds: 500), () => getDialog(true));
            points = double.parse(snapshot.data!.docs[0]['points'].toString());
          } else if (points > snapshot.data!.docs[0]['points']) {
            Future.delayed(
                const Duration(milliseconds: 500), () => getDialog(false));
            points = double.parse(snapshot.data!.docs[0]['points'].toString());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scan your Qr Code to win Points',
                  style: TextStyle(
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                QrImageView(
                  foregroundColor: const Color.fromRGBO(185, 26, 25, 1),
                  data: user.uid,
                  version: QrVersions.auto,
                  size: size.height * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  'Total Points: ${snapshot.data!.docs[0]['points']}',
                  style: TextStyle(
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$memberShipType MemberShip',
                      style: TextStyle(
                          fontSize: size.height * 0.02,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Icon(
                      Icons.star,
                      color: memberShipType == 'Red'
                          ? const Color.fromRGBO(185, 26, 25, 1)
                          : memberShipType == 'Gold'
                              ? const Color(0xffffd700)
                              : Color.fromARGB(255, 151, 151, 127),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                snapshot.data!.docs[0]['points'] >= 1000
                    ? Text(
                        'Hey, you can claim a drink',
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Image.asset(
                  'assets/lucaffeFamilia.png',
                  height: size.height * 0.2,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Center _employee(Size size) {
    return Center(
      child: Form(
        key: _key,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "Scan your client's code to give them $toGivepoints points",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.height * 0.03, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      toGivepoints = 0;
                    } else {
                      toGivepoints = double.parse(value);
                    }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Write the number of points';
                  }
                  return null;
                },
                controller: pointsController,
                keyboardType: TextInputType.number,
                readOnly: isShow == true && isRead == false ? true : false,
                decoration: const InputDecoration(
                    label: Text('Points'), border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            isShow
                ? Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
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
                        if (isShow == true && isRead == false) {
                          setState(() {
                            isShow = false;
                            isRead = true;
                          });
                        } else {
                          if (_key.currentState!.validate()) {
                            setState(() {
                              isGivePoint = true;
                              isShow = true;
                              isRead = false;
                            });
                          }
                        }
                      },
                      child: Text(
                        isShow == true && isRead == false
                            ? 'Cancel'
                            : 'Give points',
                        style: TextStyle(fontSize: size.height * 0.025),
                      ))),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            isShow == true && isRead == false
                ? const SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.25),
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
                              setState(() {
                                isGivePoint = false;
                                isShow = true;
                                isRead = false;
                              });
                            },
                            child: Text(
                              'Claim Points',
                              style: TextStyle(fontSize: size.height * 0.025),
                            ))),
                  ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(
    QRViewController controller,
  ) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isRead == false) {
        setState(() {
          isShow = false;
          result = scanData;
          isRead = true;
        });
        if (result != null && isGivePoint == true) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(result!.code)
              .get()
              .then(
            (value) {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(result!.code)
                  .update({
                'points': value['points'] + toGivepoints,
                'historialPoints': value['historialPoints'] + toGivepoints
              });
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                title: 'Qr code read successfully',
                desc:
                    'Name: ${value['nombre']}\nNumber: ${value['numero'] ?? 'Empty'}\nID: ${value['uid']}',
                btnOkOnPress: () {},
              ).show();
            },
          );
        } else if (result != null && isGivePoint == false) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(result!.code)
              .get()
              .then(
            (value) {
              if (value['points'] >= 1000) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(result!.code)
                    .update({'points': value['points'] - 1000});
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  title: 'Successful Validation',
                  desc:
                      '${value['nombre']} has successfully redeemed 1000 points\nNumber: ${value['numero'] ?? 'Empty'}\nID: ${value['uid']}',
                  btnOkOnPress: () {},
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  title: 'The client has not yet reached 1000 points',
                  btnOkOnPress: () {},
                ).show();
              }
            },
          );
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  getDialog(bool isRecived) {
    if (isRecived) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Congratulations, you have received points',
        btnOkOnPress: () {},
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Congratulations, you can claim your prize now!',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
