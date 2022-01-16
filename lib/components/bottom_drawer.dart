import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/globals.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomDrawer extends StatefulWidget {
  bool? showMenu;
  String? task;
  BottomDrawer({this.showMenu, this.task});
  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  FlutterLocalNotificationsPlugin? flutterLocalNotifications;
  bool? anonimity = false;

  @override
  void initState() {
    super.initState();
    /*var androidInitilize = new AndroidInitializationSettings('ic_launcher111');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
    flutterLocalNotifications!.initialize(initilizationSettings,
        onSelectNotification: notificationSelected);*/
  }

  bool imageloader = false;

  void uploadDoubtImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);
      var imageName = image.path.split('/').last;

      if (image != null) {
        //Upload to Firebase
        setState(() {
          imageloader = true;
        });
        var snapshot = await _storage.ref().child('$imageName').putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        print(imageUrl);
        setState(() {
          imageUrl = downloadUrl;
          imageloader = false;
        });
        /*if (type == 'forumDoubt') {
          onProvideSolution(docId);
        } else {
          onSendMessage();
        }*/
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  double doubtOpacity = 0;
  double doubtdesOpacity = 0;
  static AnimatedOpacity _label(double value, String text) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 120),
      opacity: value,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: "MontserratM",
              fontSize: width! * 0.035, //14
              color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  static TextStyle _hintText() {
    return TextStyle(
        fontFamily: "MontserratM",
        fontSize: width! * 0.061, //24
        color: Colors.black.withOpacity(0.3));
  }

  static TextStyle _inputText1() {
    return TextStyle(
      fontFamily: "MontserratSB",
      fontSize: width! * 0.061, //24
      color: Colors.black,
    );
  }

  static TextStyle _inputText2() {
    return TextStyle(
        fontFamily: "Montserrat",
        fontSize: width! * 0.045, //18
        color: Colors.black.withOpacity(0.6));
  }

  final ScrollController _scrollController = ScrollController();
  void _callOnTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
      'Channel Id',
      'Mentor mate',
      'descriptions',
      importance: Importance.max,
    );
    var iOSdetails = new IOSNotificationDetails();
    var genralNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSdetails);
    // await flutterLocalNotifications!
    //     .show(0, 'task', 'body', genralNotificationDetails);
    var scheduledTime = DateTime.now().add(Duration(seconds: 50));
    flutterLocalNotifications!.schedule(
        1,
        "Unanswered question since 2 days: ${messageTitle.text}",
        "${messageDescription.text}",
        scheduledTime,
        genralNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return AnimatedPositioned(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      left: 0,
      bottom: (widget.showMenu!)
          ? -(height * 0.164) //-140
          : -(height * 0.822), // -700
      child: Column(
        children: [
          SizedBox(
            height: height * 0.011, //10
          ),
          Container(
              height: height * 0.687, //500
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  //background color of box
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25.0, // soften the shadow
                    spreadRadius:
                        widget.showMenu! ? 500.0 : 0, //extend the shadow
                    offset: Offset(
                      15.0, // Move to right 10  horizontally
                      15.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.071,
                      vertical: height * 0.032), //28 28
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 1,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Drawerclass.showMenu = false;
                                  widget.showMenu = false;
                                  type = '';
                                });
                              },
                              child: Container(
                                height: height * 0.035, //30
                                width: width * 0.076, //30
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.black.withOpacity(0.05)),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              _label(doubtOpacity, "Doubt title"),
                              TextFormField(
                                controller: messageTitle,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
                                style: _inputText1(),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: _hintText(),
                                    hintText: "Doubt title"),
                                onChanged: (value) {
                                  setState(() {
                                    value != ''
                                        ? doubtOpacity = 1
                                        : doubtOpacity = 0;
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  _callOnTop();
                                },
                              ),
                              SizedBox(height: height * 0.011), //10
                              _label(doubtdesOpacity, "Doubt description"),
                              TextFormField(
                                controller: messageDescription,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                                style: _inputText2(),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: _hintText(),
                                    hintText: "Doubt description"),
                                onChanged: (value) {
                                  setState(() {
                                    value != ''
                                        ? doubtdesOpacity = 1
                                        : doubtdesOpacity = 0;
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  _callOnTop();
                                },
                              ),
                              SizedBox(height: height * 0.035), //30
                              Text(
                                'Attachments',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              imageUrl == null
                                  ? InkWell(
                                      onTap: () {
                                        if (widget.task == 'doubt') {
                                          setState(() {
                                            type = 'doubt';
                                          });
                                        }
                                        uploadDoubtImage();
                                      },
                                      child: Container(
                                          width: width,
                                          decoration: BoxDecoration(
                                              color: grey,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Center(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.03,
                                                vertical:
                                                    height * 0.014), //12 12
                                            child: imageloader
                                                ? Container(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 1.4,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height:
                                                            height * 0.018, //16
                                                        child: SvgPicture.asset(
                                                            'assets/paperclip.svg'),
                                                      ),
                                                      SizedBox(
                                                          width: width *
                                                              0.020), //8
                                                      Text("Attach image",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontSize: width *
                                                                  0.03, //12
                                                              color:
                                                                  Colors.black))
                                                    ],
                                                  ),
                                          ))),
                                    )
                                  : Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 40,
                                                color: grey,
                                                child: Image.network(imageUrl!),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              imageloader
                                                  ? Container(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.4,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Image Uploaded',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          color: Colors.black),
                                                    )
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                type = 'doubt';
                                              });
                                              uploadDoubtImage();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: grey,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  'Change Image',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 15),
                              widget.task != 'doubt'
                                  ? Row(
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  width: 1)),
                                          child: Transform.scale(
                                            scale: 0.9,
                                            child: Checkbox(
                                                side: BorderSide.none,
                                                checkColor: Colors.black,
                                                shape: CircleBorder(),
                                                activeColor: Colors.black,
                                                value: anonimity,
                                                onChanged: (value) {
                                                  setState(() {
                                                    anonimity = !anonimity!;
                                                  });
                                                }),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Post Anonymous',
                                          style: TextStyle(
                                              fontFamily: 'MontserratM'),
                                        )
                                      ],
                                    )
                                  : Container(),
                              SizedBox(height: 8),
                              widget.task != 'doubt'
                                  ? AnimatedOpacity(
                                      opacity: anonimity! ? 0.3 : 0,
                                      duration: Duration(microseconds: 300),
                                      child: Container(
                                        width: width,
                                        child: Text(
                                          'Posting inappropriate content while anonymous may lead to disabling your account',
                                          style: TextStyle(
                                              fontFamily: 'MontserratM'),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  Drawerclass.showMenu = false;
                                  widget.showMenu = false;
                                  /*if (type == 'forumDoubt') {
                                    onProvideSolution(docId);
                                  } else {
                                    onSendMessage(anonimity!);
                                  }*/
                                  _showNotification();
                                  onSendMessage(anonimity!);
                                },
                                child: Container(
                                  height: 40,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: Text(
                                      'Ask',
                                      style: TextStyle(
                                          fontFamily: "MontserratM",
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ])))
        ],
      ),
    );
  }

  Future notificationSelected(String? payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }
}
