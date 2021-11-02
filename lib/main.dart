import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mentor_mate/splashscreen.dart';

//import 'package:splashscreen/splashscreen.dart';
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FlutterLocalNotificationsPlugin? flutterLocalNotifications;

  // @override
  // void initState() {
  //   super.initState();
  //   var androidInitilize = new AndroidInitializationSettings('ic_launcher111');
  //   var iOSinitilize = new IOSInitializationSettings();
  //   var initilizationSettings = new InitializationSettings(android:androidInitilize,iOS:iOSinitilize);
  //   flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
  //   flutterLocalNotifications!.initialize(initilizationSettings,
  //   onSelectNotification: notificationSelected );
  // }

  @override
  Widget build(BuildContext context) {
    // Future notificationSelected(String payload)async{

    // }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:
            SplashScreen() /*SlashScreen(
          useLoader: false,
          photoSize: 40,
          image: Image.asset("assets/logo.png"),
          seconds: 2,
          navigateAfterSeconds: new TeacherHome(),
          backgroundColor: Colors.white,
        )*/
        );
  }
  // Future notificationSelected(String? payload)async{

  //   }
}
