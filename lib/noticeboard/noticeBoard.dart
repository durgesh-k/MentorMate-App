import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mentor_mate/authentication/authenticate.dart';
import 'package:mentor_mate/components/imageLarge.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/noticeboard/noticeArchive.dart';
import 'package:mentor_mate/noticeboard/postNotice.dart';

String noticeYear = '';
String noticeBranch = '';
TextEditingController? noticeTitle = TextEditingController();
TextEditingController? noticeDescription = TextEditingController();
DateTime selectedDate = DateTime.now();
String? noticeImage;
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void onAddNotice() async {
  try {
    Map<String, dynamic> notice = {
      'year': noticeYear,
      'branch': noticeBranch,
      'title': noticeTitle!.text,
      'description': noticeDescription!.text,
      'servertimestamp': FieldValue.serverTimestamp(),
      'difference': daysBetween(DateTime.now(),
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day)),
      'imageUrl': noticeImage,
      'deadline': [selectedDate.day, selectedDate.month, selectedDate.year]
    };
    await FirebaseFirestore.instance.collection('Notice').add(notice);
    noticeTitle!.clear();
    noticeDescription!.clear();
    selectedDate = DateTime.now();
    noticeImage = null;
    Fluttertoast.showToast(
        msg: 'Notice posted',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: grey,
        textColor: Colors.black,
        fontSize: 16.0);
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Error posting notice',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

class NoticeBoard extends StatefulWidget {
  final Map<String, dynamic> userMap;
  const NoticeBoard({required this.userMap});

  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  bool chose = false;
  String chosenYear = 'Year';
  String chosenBranch = 'Branch';
  var stream = FirebaseFirestore.instance
      .collection('Notice')
      .orderBy('difference')
      .snapshots();

  void fetchNotice(bool chose, String chosenYear, String chosenBranch) {
    if (chose) {
      if (chosenYear != 'Year' && chosenBranch == 'Branch') {
        setState(() {
          stream = FirebaseFirestore.instance
              .collection('Notice')
              .where('year', isEqualTo: chosenYear)
              .orderBy('difference')
              .snapshots();
        });
      } else if (chosenYear == 'Year' && chosenBranch != 'Branch') {
        setState(() {
          stream = FirebaseFirestore.instance
              .collection('Notice')
              .where('branch', isEqualTo: chosenBranch)
              .orderBy('difference')
              .snapshots();
        });
      } else if (chosenYear != 'Year' && chosenBranch != 'Branch') {
        setState(() {
          stream = FirebaseFirestore.instance
              .collection('Notice')
              .where('year', isEqualTo: chosenYear)
              .where('branch', isEqualTo: chosenBranch)
              .orderBy('difference')
              .snapshots();
        });
      } else {
        setState(() {
          stream = FirebaseFirestore.instance
              .collection('Notice')
              .orderBy('difference')
              .snapshots();
        });
      }
    } else {
      setState(() {
        stream = FirebaseFirestore.instance
            .collection('Notice')
            .orderBy('difference')
            .snapshots();
      });
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      chose = false;
    });
  }

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
        actions: [
          role == 'student'
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NoticeArchive(userMap: widget.userMap)));
                      },
                      icon: Icon(
                        Iconsax.folder_minus,
                        color: Colors.black,
                      )),
                )
              : Container()
        ],
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
                    'Notice Board',
                    style: TextStyle(
                        fontFamily: "MontserratB",
                        fontSize: 28,
                        color: Colors.black),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 26,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: role == 'teacher'
                              ? DropdownButton<String>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      chosenYear,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  items: <String>['FY', 'SY', 'TY', 'BTech']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  icon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 12,
                                    ),
                                  ),
                                  underline: SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      chose = true;
                                      chosenYear = value!;
                                    });
                                    fetchNotice(
                                        chose, chosenYear, chosenBranch);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.userMap['year'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 26,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Center(
                          child: role == 'teacher'
                              ? DropdownButton<String>(
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      chosenBranch,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  items: <String>['CSE', 'IT', 'ENTC', 'MECH']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  icon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Icon(
                                      Iconsax.arrow_down_1,
                                      size: 12,
                                    ),
                                  ),
                                  underline: SizedBox(),
                                  onChanged: (value) {
                                    setState(() {
                                      chose = true;
                                      chosenBranch = value!;
                                    });
                                    fetchNotice(
                                        chose, chosenYear, chosenBranch);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.userMap['branch'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 18,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: stream,
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
                            if (role == 'student') {
                              return daysBetween(date1, date2) >= 0
                                  ? map['year'] == widget.userMap['year'] &&
                                          map['branch'] ==
                                              widget.userMap['branch']
                                      ? NoticsCard(map: map)
                                      : Container()
                                  : Container();
                            } else {
                              return daysBetween(date1, date2) >= 0
                                  ? NoticsCard(map: map)
                                  : Container();
                            }
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: role == 'teacher'
          ? InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClassChoice()));
              },
              child: Container(
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'New',
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}

class NoticsCard extends StatefulWidget {
  final Map<String, dynamic> map;
  const NoticsCard({required this.map});

  @override
  _NoticsCardState createState() => _NoticsCardState();
}

class _NoticsCardState extends State<NoticsCard> {
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    final diff = daysBetween(
        DateTime.now(),
        DateTime(widget.map['deadline'][2], widget.map['deadline'][1],
            widget.map['deadline'][0]));
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Container(
        color: diff < 8
            ? diff < 0
                ? Colors.transparent
                : Colors.red.withOpacity(0.2)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Container(
                  width: width,
                  child: Text(
                    '${widget.map['year']} ${widget.map['branch']}',
                    style: TextStyle(
                        fontFamily: "MontserratSB",
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.2)),
                  )),
              SizedBox(
                height: 6,
              ),
              widget.map['title'] != null
                  ? Container(
                      width: width,
                      child: Text(
                        '- ${widget.map['title']}',
                        style: TextStyle(
                            fontFamily: "MontserratSB",
                            fontSize: 24,
                            color: diff < 0
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black),
                      ))
                  : Container(),
              SizedBox(
                height: 10,
              ),
              widget.map['deadline'] != null
                  ? Container(
                      width: width,
                      child: Row(
                        children: [
                          Text(
                            daysBetween(
                                    DateTime.now(),
                                    DateTime(
                                        widget.map['deadline'][2],
                                        widget.map['deadline'][1],
                                        widget.map['deadline'][0]))
                                .toString(),
                            style: TextStyle(
                                fontFamily: "MontserratSB",
                                fontSize: 14,
                                color: diff < 0
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.black),
                          ),
                          Text(
                            ' days to deadline',
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 14,
                                color: diff < 0
                                    ? Colors.black.withOpacity(0.2)
                                    : Colors.black),
                          )
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 7,
              ),
              widget.map['description'] != null
                  ? Container(
                      width: width,
                      child: Text(
                        widget.map['description'],
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 20,
                            color: diff < 0
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black),
                      ))
                  : Container(),
              SizedBox(
                height: 10,
              ),
              widget.map['imageUrl'] != null
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ImageLarge(imageurl: widget.map['imageUrl'])));
                      },
                      child: Hero(
                        tag: widget.map['imageUrl'],
                        child: Container(
                          width: width,
                          height: 400,
                          color: grey,
                          child: Image.network(
                            widget.map['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
