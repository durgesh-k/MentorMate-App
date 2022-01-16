import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/components/popup.dart';

class Report extends StatefulWidget {
  final String? docId;
  final String? docId2;
  final Map<String, dynamic>? map;
  final String? collection;
  const Report({this.docId, this.docId2, this.map, this.collection});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  static const String _heroReport = 'report';
  List reasons = [
    'Foul language',
    'Hate Speech',
    'Bullying or harrassment',
    'Suicide or self-injury',
    'Violence',
    'Other'
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroReport,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: <Widget>[
                        Icon(Iconsax.info_circle, color: Colors.red.shade400),
                        SizedBox(width: 5),
                        Text(
                          "Report",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.red.shade400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                          width: 300,
                          child: Text(
                            'Why are you reporting this post?',
                            style: TextStyle(
                                fontFamily: 'MontserratSB', fontSize: 20),
                          )),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: reasons.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              addReport(
                                  widget.map!['uid'],
                                  FirebaseAuth.instance.currentUser!.uid,
                                  reasons[index],
                                  widget.docId!,
                                  widget.collection!,
                                  widget.docId2 == 'null'
                                      ? 'null'
                                      : widget.docId2!);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 200,
                              height: 28,
                              child: Text(
                                reasons[index],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
