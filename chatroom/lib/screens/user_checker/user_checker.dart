import 'package:flutter/material.dart';

class UserChecker extends StatefulWidget {
  const UserChecker({super.key});

  @override
  State<UserChecker> createState() => _UserCheckerState();
}

class _UserCheckerState extends State<UserChecker> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkUserSessionAndNavigate() {
    final userStore = Provider.of<UserStore>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString('userID');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}