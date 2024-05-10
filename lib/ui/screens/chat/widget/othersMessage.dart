import 'package:flutter/material.dart';
import 'package:flutterquiz/ui/screens/chat/chat_screen.dart';
import 'package:flutterquiz/ui/screens/chat/model/messageModel.dart';
import 'package:flutterquiz/ui/screens/chat/widget/formatTime.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/circularImage.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class OthersMessage extends StatelessWidget {
  String? prevMessageUserId;
  
  String? nextMessageUserId;
  
  final double hzMargin;
  
  final MessageModel messageData;

   OthersMessage({
    super.key, this.prevMessageUserId, this.nextMessageUserId,required this.hzMargin, required this.messageData,
    

  });

  
  




  @override
  Widget build(BuildContext context) {
  
    final textStyle = GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeights.regular,
        color: Colors.black.withOpacity(.8),
        // color: Colors.black.withOpacity(.9),
      ),
    );
      final textStyle2 = GoogleFonts.nunito(
      textStyle:const  TextStyle(
        fontSize: 17,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeights.regular,
        color: Colors.white,
      ),
    );
        double scrWidth = MediaQuery.of(context).size.width;

    double scrHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: hzMargin, top: scrHeight * .02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircularImage(
              width: scrWidth * .07,
              height: scrWidth * .07,
              imageUrl: messageData.senderProfileUrl),
          SizedBox(width: scrWidth * .03),
          Container(
            constraints: BoxConstraints(
              maxWidth: scrWidth * .7,
            ),
            padding:  EdgeInsets.all(scrWidth * .015),
            decoration: BoxDecoration(
              color: messageData.unsent
                    ? badgeLockedColor
                    : darkCanvasColor,
                // color: darkCanvasColor,
                borderRadius: BorderRadius.only(
                    topLeft: prevMessageUserId != null && prevMessageUserId == messageData.senderId ? const Radius.circular(5.0) : Radius.circular(hzMargin),  
                  topRight:  Radius.circular(hzMargin), 
                  bottomLeft: nextMessageUserId !=null && nextMessageUserId == messageData.senderId? const Radius.circular(5.0) : Radius.circular(hzMargin), 
                  bottomRight:  Radius.circular(hzMargin), 
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Text(
                    // stringList[4],
                    messageData.unsent ? "unsent message" : messageData.text,
                    style: messageData.unsent ? textStyle2 : textStyle,
                  )
              ,
                Text(
                    formatDateTime(messageData.time),
                   style:  TextStyle(fontSize: 10,color:messageData.unsent ?Colors.white: Colors.black),
                  ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

