import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_mate/chat/firebase.dart';
import 'package:mentor_mate/chat_screen.dart';
import 'package:mentor_mate/components/doubt_card.dart';
import 'package:mentor_mate/components/popup.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/search.dart';
import 'package:mentor_mate/teacher_chat_screen.dart';

enum SinginCharacter { lowToHigh, highToLow, alphabetically }

// getUSersTrip() async {
//   var datas = await FirebaseFirestore.instance
//       .collection('chatroom')
//       .doc(widget.chatRoomId)
//       .collection('chats')
//       .doc(chatRoomId)
//       .collection('doubts')
//       .orderBy('time', descending: false)
//       .get();
//       return data.documents
// }

class FormDart extends StatefulWidget {
  Map<String, dynamic> teacherMap;
  FormDart({
    required this.teacherMap,
  });
  @override
  _FormDartState createState() => _FormDartState();
}

class _FormDartState extends State<FormDart> {
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    print(_searchController.text);
  }

  String query = "";
  SinginCharacter _character = SinginCharacter.alphabetically;
  var data;
  @override
  Widget build(BuildContext context) {
    print("This is form data");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Forum',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                print("This is form data");
                Navigator.pop(context);
              },
              child: Container(
                  height: height! * 0.035, //30
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
        ),
        body: Column(
          children: [
            InkWell(
                child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Search(
                                search: _searchController.text,
                                teacherMap: widget.teacherMap,
                              )));
                }),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('doubts')
                  .orderBy('servertimestamp', descending: false)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> usersnapshot) {
                if (usersnapshot.connectionState == ConnectionState.waiting) {
                  // print("aSADSA...............................");
                  // print( usersnapshot.data!.docs[].data());
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: usersnapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          print("aSADSA...............................");
                          data = usersnapshot.data!.docs[index].data();
                          // print(usersnapshot.data!.docs[index].data());
                          Map<String, dynamic> map =
                              usersnapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          print(map['type'] == 'doubt');
                          print("look above.................................");
                          return map['type'] == 'doubt'
                              ? ForumCard(
                                  map: map,
                                  teacherMap: widget.teacherMap,
                                )
                              : Container(
                                  child: Text("hello"),
                                  height: 0,
                                );
                        }),
                  );
                }
              },
            ),
          ],
        ));
  }
}

class ForumCard extends StatefulWidget {
  Map<String, dynamic> map;
  Map<String, dynamic> teacherMap;
  ForumCard({required this.map, required this.teacherMap});
  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final grey = const Color(0xFFe0e3e3).withOpacity(0.5);
    return Container(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.045, vertical: height * 0.021), //18 18
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.05), //20
              child: Container(
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.map['name'],
                      style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: width * 0.035, //14
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      width: width * 0.025, //10
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        width: width,
                        color: grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: 2,
                  bottom: height * 0.011), // 20 2 10
              child: Text(
                widget.map['studentKey'],
                style: TextStyle(
                    fontFamily: "MontserratM",
                    fontSize: width * 0.04, //16
                    color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Row(
              children: [
                Container(
                  height: height * 0.023, //20
                  width: width * 0.05, //20
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/round.svg',
                      height: 5,
                    ),
                  ),
                ),
                Text(widget.map['title'],
                    style: TextStyle(
                      fontFamily: "MontserratSB",
                      fontSize: width * 0.061, //24
                      color: Colors.black,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: height * 0.011,
                  bottom: height * 0.011), //20 10 10
              child: Text(
                widget.map['description'],
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: width * 0.045, //18
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.009), //20 8
              child: Text(widget.map['time'],
                  style: TextStyle(
                      fontFamily: "MontserratM",
                      fontSize: width * 0.035, //14
                      color: Colors.black.withOpacity(0.3))),
            ),
            (widget.map['image_url'] != null)
                ? Image.network(widget.map['image_url']!)
                : Container(
                    height: 0,
                  ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: height * 0.011), //20 10
              child: InkWell(
                onTap: () {
                  String roomId2 =
                      chatRoomId(widget.map['to'], widget.map['name']);
                  print("this is chatroomid");
                  print(roomId2);
                  setState(() {
                    roomId = roomId2;
                    to = widget.map['name'];
                    print(roomId2);
                    print(
                        "This is ....................................................................................");
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ForumChatScreen(
                            chatRoomId: roomId2,
                            userMap: widget.map,
                          )));
                },
                child: Container(
                  height: height * 0.047, //40
                  width: width * 0.254, //100
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: grey,
                  ),
                  //border: Border.all(width: 1)),
                  child: Center(
                    child: Text('Answers',
                        style: TextStyle(
                          fontFamily: "MontserratM",
                          fontSize: width * 0.037, //15
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumChatScreen extends StatefulWidget {
  String chatRoomId;
  Map<String, dynamic> userMap;

  ForumChatScreen({required this.chatRoomId, required this.userMap});

  @override
  _ForumChatScreenState createState() => _ForumChatScreenState();
}

class _ForumChatScreenState extends State<ForumChatScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    const String _heroAddTodo = 'add-todo-hero';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.082), //70
        child: AppBar(
          leadingWidth: height * 0.082, //70
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: height * 0.035, //30
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Center(child: SvgPicture.asset('assets/back.svg')))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userMap['name'],
                style: TextStyle(
                    fontFamily: "MontserratB",
                    fontSize: 16, //24
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                widget.userMap['studentKey'],
                style: TextStyle(
                    fontFamily: "MontserratM",
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.4)),
              ),
            ],
          ),
          
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroom')
                          .doc(widget.chatRoomId)
                          .collection('chats')
                          .doc(widget.chatRoomId)
                          .collection('doubts')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;

                                /*if (map['id'] != null) {
                                    setState(() {
                                      id = map['id'];
                                      print(
                                          'inside setState-------------------------------');
                                      print(id);
                                    });
                                  }*/
                                if(widget.userMap['id']==map['id']){
                                    
                                  return map['type'] == 'message'
                                      ? Message(
                                          check: 'student',
                                          map: map,
                                        )
                                      : DoubtMessage(map: map);
                                
                                }else {
                          print("Tjhis is empty container");
                          return Container();
                        }
                              });
                        } else {
                          print("Tjhis is empty container");
                          return Container();
                        }
                      })),
              //Container(width: width, child: TextInput()),
            ],
          ),
        ],
      ),
    );
  }
}
