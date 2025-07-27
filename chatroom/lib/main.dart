import 'package:chatroom/shared/styled_button.dart';
import 'package:chatroom/shared/styled_text.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => UserStore(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room',
      theme: primaryTheme,      
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
