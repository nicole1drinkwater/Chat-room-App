import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/push_notifications.dart';
import 'package:chatroom/shared/styled_button.dart';
import 'package:chatroom/shared/styled_text.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:provider/provider.dart';
import 'package:chatroom/screens/user_checker/user_checker.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  print("hello");
  if (message.notification != null) {
    print("Some notification received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {      
      print("Some notification received");
      navigatorKey.currentState!.pushNamed("/chatroom", arguments: message);
    }
  });
 
  PushNotifications.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("hi");
  });

  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(
          create: (context) => UserStore()
        ),
        
        ChangeNotifierProvider(
          create: (context) => MessageStore()
        ),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Chat Room',
      theme: primaryTheme,      
      home: const SignInScreen(),
      routes: {
        '/chatroom': (context) => const ChatRoomScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
            const StyledTitle(
              'Add a new account',
            ),
            
            StyledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ));
              },
              child: const StyledText('Welcome'),
            ),
          ],
        ),
      ),
    );
  }
}
