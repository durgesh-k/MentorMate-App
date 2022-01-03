import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_mate/globals.dart';
import 'package:mentor_mate/noticeboard/noticeBoard.dart';
import 'package:permission_handler/permission_handler.dart';

class ClassChoice extends StatefulWidget {
  const ClassChoice({Key? key}) : super(key: key);

  @override
  _ClassChoiceState createState() => _ClassChoiceState();
}

class _ClassChoiceState extends State<ClassChoice> {
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
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notice for -',
              style: TextStyle(
                fontFamily: "MontserratB",
                fontSize: 36,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
                radius: 320,
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  setState(() {
                    noticeYear = 'FY';
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BranchChoice()));
                },
                child: Container(
                    child: Text(
                  '- First Year',
                  style: TextStyle(
                    fontFamily: "MontserratSB",
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ))),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeYear = 'SY';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BranchChoice()));
              },
              child: Container(
                  child: Text(
                '- Second Year',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeYear = 'TY';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BranchChoice()));
              },
              child: Container(
                  child: Text(
                '- Third Year',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeYear = 'BTech';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BranchChoice()));
              },
              child: Container(
                  child: Text(
                '- BTech',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
          ],
        ),
      )),
    );
  }
}

class BranchChoice extends StatefulWidget {
  const BranchChoice({Key? key}) : super(key: key);

  @override
  _BranchChoiceState createState() => _BranchChoiceState();
}

class _BranchChoiceState extends State<BranchChoice> {
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
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notice for -',
              style: TextStyle(
                fontFamily: "MontserratB",
                fontSize: 36,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
                radius: 320,
                splashColor: Colors.black.withOpacity(0.2),
                onTap: () {
                  setState(() {
                    noticeBranch = 'CSE';
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewNotice()));
                },
                child: Container(
                    child: Text(
                  '- Computer Science',
                  style: TextStyle(
                    fontFamily: "MontserratSB",
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ))),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeBranch = 'IT';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewNotice()));
              },
              child: Container(
                  child: Text(
                '- Information Technology',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeBranch = 'ENTC';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewNotice()));
              },
              child: Container(
                  child: Text(
                '- Electronics',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              radius: 320,
              splashColor: Colors.black.withOpacity(0.2),
              onTap: () {
                setState(() {
                  noticeBranch = 'MECH';
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewNotice()));
              },
              child: Container(
                  child: Text(
                '- Mechanical',
                style: TextStyle(
                  fontFamily: "MontserratSB",
                  fontSize: 26,
                  color: Colors.black,
                ),
              )),
            ),
          ],
        ),
      )),
    );
  }
}

class NewNotice extends StatefulWidget {
  const NewNotice({Key? key}) : super(key: key);

  @override
  _NewNoticeState createState() => _NewNoticeState();
}

class _NewNoticeState extends State<NewNotice> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateOpacity = 1;
      });
  }

  double doubtOpacity = 0;
  double doubtdesOpacity = 0;
  double dateOpacity = 0;
  double imageOpacity = 0;
  bool loader = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noticeTitle!.clear();
    noticeDescription!.clear();
  }

  void uploadNoticeImage() async {
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
        setState(() {
          loader = true;
        });
        //Upload to Firebase
        var snapshot = await _storage.ref().child('$imageName').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          noticeImage = downloadUrl;
          loader = false;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
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
        title: Text(
          'Notice',
          style: TextStyle(
              fontFamily: "MontserratB", fontSize: 24, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label(doubtOpacity, "Title"),
              TextFormField(
                controller: noticeTitle,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: _inputText1(),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: _hintText(),
                    hintText: "Title"),
                onChanged: (value) {
                  setState(() {
                    value != '' ? doubtOpacity = 1 : doubtOpacity = 0;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              _label(doubtdesOpacity, "Description"),
              TextFormField(
                controller: noticeDescription,
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
                    hintText: "Description"),
                onChanged: (value) {
                  setState(() {
                    value != '' ? doubtdesOpacity = 1 : doubtdesOpacity = 0;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              _label(dateOpacity, "Deadline"),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await _selectDate(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: 16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      dateOpacity == 1
                          ? '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'
                          : 'Set Deadline',
                      style: _hintText(),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _label(
                  imageOpacity, noticeImage == null ? "Image" : "Change Image"),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  uploadNoticeImage();
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.gallery,
                      size: 16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Image',
                      style: _hintText(),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    loader
                        ? Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              noticeImage != null
                  ? Container(
                      height: 200,
                      width: 200,
                      color: grey,
                      child: Image.network(
                        noticeImage!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container()
            ]),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: InkWell(
                  onTap: () {
                    onAddNotice();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: width,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Post',
                        style: TextStyle(
                            fontFamily: 'MontserratSB',
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
