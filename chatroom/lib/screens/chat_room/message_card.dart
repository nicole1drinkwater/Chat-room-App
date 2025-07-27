import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../../services/firestore_service.dart';
import '../../shared/styled_button.dart';
import '../../shared/styled_text.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(this.message, {super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Image.asset('assets/img/vocations/${message.id}', 
              width: 80
            ),

            const SizedBox(width: 20),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledHeading(character.name),
                StyledText(character.vocation.title),
              ]
            ),

            const Expanded(
              child: SizedBox(),
            ),
            
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Profile(character: character)
                ));
              },
              icon: Icon(Icons.arrow_forward, color: AppColors.textColor)
            ),
          ]
        ),
      ),
    );
  }
}