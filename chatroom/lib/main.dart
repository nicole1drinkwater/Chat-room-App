import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/push_notifications.dart';
import 'package:chatroom/shared/styled_button.dart';
import 'package:chatroom/shared/styled_text.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {      
      navigatorKey.currentState!.pushNamedAndRemoveUntil("/", (route) => false);
  }});
 
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
      initialRoute: "/",
      routes: {
        '/chatroom': (context) => const ChatRoomScreen(),
        '/': (context) => const UserChecker(),
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
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('assets/icon/app_icon.png',
              height: 100, ),
              
              const SizedBox(height: 24),

              const StyledTitle(
                'Welcome to Chat Room',
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const StyledText(
                'Create an account to start chatting with people right now.',
                color: Colors.black54,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              Center(
                child: StyledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const StyledText('Get Started'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}