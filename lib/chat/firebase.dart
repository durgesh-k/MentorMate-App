import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/globals.dart';
import 'package:permission_handler/permission_handler.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
Map<String, dynamic>? userMap;

String docIdforRequests = '';

String chatRoomId(String user1, String user2) {
  if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

String roomId = chatRoomId(auth.currentUser!.uid, userMap?['uid'] ?? 'gcyj');

void onProvideSolution(String? docId) async {
  var user;
  role == 'student'
      ? await _firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        })
      : await _firestore
          .collection("Teachers")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        });

  if (message.text.isNotEmpty || imageUrl != null) {
    final DateTime now = DateTime.now();
    Map<String, dynamic> messages = {
      'id': id,
      "sendby": user['role'].toString(),
      'to': to,
      'type': type,
      'solved': false,
      "message": message.text,
      "time": '${now.hour} : ${now.minute}',
      'name': user['name'].toString(),
      'image_url': imageUrl,
      'servertimestamp': FieldValue.serverTimestamp(),
      'searchKeywords': '{$messageTitle[0]}',
      'uid': FirebaseAuth.instance.currentUser!.uid
    };
    message.clear();
    await _firestore
        .collection('Forum')
        .doc(docId)
        .collection('solutions')
        .add(messages);
  } else {
    print('Error in text');
  }
}

void getUser() async {
  _firestore.collection("users").doc(auth.currentUser!.uid).get().then((value) {
    print(value.data());
    print(value.data()!['name']);
    currentUser = value.data()!['name'];
  });
}

void onSendMessage(bool anonimity) async {
  var user;
  print('--this is role-------$role');
  role == 'student'
      ? await _firestore
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        })
      : await _firestore
          .collection("Teachers")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
          print(value.data());
          print(value.data()!['name']);
          currentUser = value.data()!['name'];
          user = value.data();
        });

  if (message.text.isNotEmpty || messageTitle.text.isNotEmpty) {
    print(message.text);
    final DateTime now = DateTime.now();
    print(user['name']);
    print('this is type--$type');
    if (type != 'forumDoubt') {
      if (message.text.isNotEmpty) {
        if (message.text == "https://meet.google.com/wax-ncmq-eim") {
          print(message.text);
          if (user['role'] == 'student') {
            id = user['messageId'];
          }
          type = 'link';
        } else {
          if (user['role'] == 'student') {
            id = user['messageId'];
          }
          type = 'message';
          print(message.text);
        }
      } else if (messageTitle.text.isNotEmpty) {
        id = Random().nextInt(100000);
        _firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({'messageId': id});
        type = 'doubt';
      }
    }
    //for (int i = 0; i < messageTitle.toString().length; i++) {}
    Map<String, dynamic> messages = {
      'id': id,
      "sendby": user['role'].toString(),
      'to': to,
      'type': type,
      'meet_at': selectedTime.toString(),
      'description': messageDescription.text,
      'solved': false,
      "message": message.text,
      'title': messageTitle.text,
      "time": '${now.hour} : ${now.minute}',
      'name': user['name'].toString(),
      'anonymous': anonimity,
      'studentKey':
          '${user['year']} ${user['branch']} ${user['div']} ${user['roll']}',
      'image_url': imageUrl,
      'servertimestamp': FieldValue.serverTimestamp(),
      'searchKeywords': '{$messageTitle[0]}',
      'uid': FirebaseAuth.instance.currentUser!.uid
    };
    message.clear();
    messageTitle.clear();
    messageDescription.clear();
    imageUrl = null;
    if (type == 'doubt') {
      addDoubts(messages);
    } else if (type == 'forumDoubt') {
      addForumDoubts(messages);
    }
    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(roomId)
        .collection('doubts')
        .add(messages)
        .then((value) => docIdforRequests = value.id);

    type = null;
  } else {
    print('Enter Some Text');
  }
}

void addDoubts(Map<String, dynamic> doubtmessage) async {
  await _firestore.collection('doubts').add(doubtmessage);
}

void addForumDoubts(Map<String, dynamic> doubtmessage) async {
  await _firestore.collection('Forum').add(doubtmessage);
}

void uploadImage(bool? anonymity) async {
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
      var snapshot = await _storage.ref().child('$imageName').putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      imageUrl = downloadUrl;
      print(imageUrl);

      if (type == 'forumDoubt') {
        onProvideSolution(docId);
      } else {
        onSendMessage(anonymity!);
      }
    } else {
      print('No Path Received');
    }
  } else {
    print('Grant Permissions and try again');
  }
}

void addRequest(String to, String from, String fromUid, String toUid) async {
  String roomIdreq = chatRoomId(fromUid, toUid);
  Map<String, dynamic> request = {
    'to': to,
    'from': from,
    'to_uid': toUid,
    'from_uid': fromUid,
    'doc_id': docIdforRequests,
  };
  print('inside request-------------------------');
  await _firestore.collection('request').doc(roomIdreq).set(request);
}

void sendImage(String? chatroomId) async {
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
      var snapshot = await _storage.ref().child('$imageName').putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      var user;
      role == 'student'
          ? await _firestore
              .collection("Users")
              .doc(auth.currentUser!.uid)
              .get()
              .then((value) {
              print(value.data());
              print(value.data()!['name']);
              currentUser = value.data()!['name'];
              user = value.data();
            })
          : await _firestore
              .collection("Teachers")
              .doc(auth.currentUser!.uid)
              .get()
              .then((value) {
              print(value.data());
              print(value.data()!['name']);
              currentUser = value.data()!['name'];
              user = value.data();
            });
      final DateTime now = DateTime.now();
      Map<String, dynamic> messages = {
        'id': id,
        "sendby": user['role'].toString(),
        'to': to,
        'type': 'message',
        'description': null,
        'solved': false,
        "message": null,
        'title': null,
        "time": '${now.hour} : ${now.minute}',
        'name': user['name'].toString(),
        'studentKey':
            '${user['year']} ${user['branch']} ${user['div']} ${user['roll']}',
        'image_url': downloadUrl,
        'servertimestamp': FieldValue.serverTimestamp(),
        'searchKeywords': '{$messageTitle[0]}',
        'uid': FirebaseAuth.instance.currentUser!.uid
      };
      await _firestore
          .collection('chatroom')
          .doc(chatroomId)
          .collection('chats')
          .doc(chatroomId)
          .collection('doubts')
          .add(messages);
    }
  }
}

Future<void> addReport(String against, String from, String reason, String doc,
    String collection, String doc2) async {
  Map<String, dynamic> map = {
    'against': against,
    'from': from,
    'reason': reason,
    'doc': doc,
    'doc2': doc2,
    'collection': collection,
    'action_taken': false,
    'servertimestamp': FieldValue.serverTimestamp(),
  };
  await _firestore.collection('Reports').add(map);
  Fluttertoast.showToast(
      msg: 'Reported the message',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: grey,
      textColor: Colors.black,
      fontSize: 16.0);
}
