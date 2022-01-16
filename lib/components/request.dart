import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/models/models.dart';
import 'package:mentor_mate/teacher_chat_screen.dart';

class RequestList extends StatefulWidget {
  final Map<String, dynamic> teacherMap;
  RequestList({required this.teacherMap});
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            PhosphorIcons.arrow_left,
            color: Colors.black,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Notifications',
            style: TextStyle(fontFamily: "MontserratB", color: Colors.black),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('request').snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 0,
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: usersnapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, index) {
                    Map<String, dynamic> map = usersnapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    print('--------------this is map2-------');
                    print(map);
                    return map['to_uid'] == widget.teacherMap['uid']
                        ? RequestSentCard(
                            map: map,
                            docId: usersnapshot.data!.docs[index].id,
                          )
                        : Container(height: 0);
                  });
            }
          }),
    );
  }
}

class RequestSentCard extends StatefulWidget {
  Map<String, dynamic> map;
  final String docId;
  RequestSentCard({required this.map, required this.docId});
  @override
  _RequestSentCardState createState() => _RequestSentCardState();
}

class _RequestSentCardState extends State<RequestSentCard> {
  String _heroAddTodo = 'add-todo-hero';

  Future deleteRequest(String docID) async {
    await FirebaseFirestore.instance
        .collection('request')
        .doc(widget.docId)
        .delete();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      radius: 320,
      splashColor: Colors.black.withOpacity(0.2),
      onTap: () async {
        String roomId1 =
            chatRoomId(widget.map['from_uid'], widget.map['to_uid']);
        setState(() {
          type = 'link';
          roomId = roomId1;
        });
        await _selectTime(context);
        print(message.text);
        message.text = "https://meet.google.com/wax-ncmq-eim";
        print(message.text);
        onSendMessage(false);
        deleteRequest(widget.docId);
        Fluttertoast.showToast(
            msg: 'Meet accepted',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: grey,
            textColor: Colors.black,
            fontSize: 16.0);
        /*var doc = FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.map['from_uid'])
            .get()
            .then((value) {
          Map<String, dynamic>? usermap = value.data();
          print('val--$usermap');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TeacherChatScreen(
                    chatRoomId: roomId1,
                    userMap: usermap,
                    //id:widget.map['id']
                  )));
        });*/
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.0045), //12 4
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: height * 0.094, //80
              width: width,
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.045), //18
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: height * 0.023, //20
                            child: SvgPicture.asset('assets/meet.svg'),
                          ),
                          SizedBox(
                            width: width * 0.05, //20
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.map['from']}',
                                style: TextStyle(
                                    fontFamily: "MontserratB",
                                    fontSize: width * 0.035 //16
                                    ),
                              ),
                              Text(
                                'Requested for a meet',
                                style: TextStyle(
                                    fontFamily: "MontserratM",
                                    fontSize: width * 0.04 //16
                                    ),
                              ),
                              Text(
                                'Tap this alert to accept',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: "MontserratM",
                                    fontSize: 12 //16
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            deleteRequest(widget.docId);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black.withOpacity(0.4),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
