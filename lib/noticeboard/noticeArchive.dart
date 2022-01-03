import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mentor_mate/noticeboard/noticeBoard.dart';

class NoticeArchive extends StatefulWidget {
  final Map<String, dynamic> userMap;
  const NoticeArchive({required this.userMap});

  @override
  _NoticeArchiveState createState() => _NoticeArchiveState();
}

class _NoticeArchiveState extends State<NoticeArchive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Iconsax.arrow_left4,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notice Archive',
                    style: TextStyle(
                        fontFamily: "MontserratB",
                        fontSize: 28,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Notice')
                    .orderBy('difference')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                  if (usersnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: usersnapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            Map<String, dynamic> map =
                                usersnapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            var date1 = DateTime.now();
                            var date2 = DateTime(map['deadline'][2],
                                map['deadline'][1], map['deadline'][0]);

                            return map['year'] == widget.userMap['year'] &&
                                    map['branch'] == widget.userMap['branch'] &&
                                    daysBetween(
                                            DateTime.now(),
                                            DateTime(
                                                map['deadline'][2],
                                                map['deadline'][1],
                                                map['deadline'][0])) <
                                        0
                                ? NoticsCard(map: map)
                                : Container();
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
