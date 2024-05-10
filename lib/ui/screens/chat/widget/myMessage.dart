import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterquiz/ui/screens/chat/model/messageModel.dart';
import 'package:flutterquiz/ui/screens/chat/widget/formatTime.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class MyMessage extends StatelessWidget {
  MyMessage({
    super.key,
    required this.messageData,
    this.prevMessageUserId,
    this.nextMessageUserId,
    required this.hzMargin,
    required this.onLongPress,
  });

  final String? prevMessageUserId;
  final String? nextMessageUserId;
  final MessageModel messageData;
  final double hzMargin;
  final Function() onLongPress;



  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeights.regular,
        color: Colors.white.withOpacity(.9),
      ),
    );
    final textStyle2 = GoogleFonts.nunito(
      textStyle: const TextStyle(
        fontSize: 17,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeights.regular,
        color: Colors.white,
      ),
    );
    double scrWidth = MediaQuery.of(context).size.width;

    double scrHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(right: hzMargin, top: scrHeight * .02),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: scrWidth * .7,
                  ),
                  padding:  EdgeInsets.all(scrWidth * .015),
                  decoration: BoxDecoration(
                    color: messageData.unsent
                        ? badgeLockedColor
                        : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(

                      topLeft:   Radius.circular(hzMargin+8),
                        topRight:   Radius.circular(hzMargin+8),
                        bottomLeft:  Radius.circular(hzMargin+8),
                        bottomRight:   Radius.circular(hzMargin+8),
                    ),
                  ),
                  child: Text(
            
                    messageData.unsent ? "unsent message" : messageData.text,
                    style: messageData.unsent ? textStyle2 : textStyle,
                  ),
                ),
                Padding( 
                  padding:EdgeInsets.only(top:scrWidth * .005,  right: scrWidth * .01), 
                  child: Text(
                      formatDateTime(messageData.time),
                      style: const TextStyle(fontSize: 10, color: Colors.black),
                    ),
                ),
              
              ],
            ),

            SizedBox(
              width: scrWidth * .01,
            ),
            Container(
              width: scrWidth * .03,
              height: scrWidth * .03,
              decoration: BoxDecoration(
                  color: messageData.sent ? secondaryColor : Colors.transparent,
                  border: Border.all(
                    width: scrWidth * .004,
                    color:
                        messageData.sent ? Colors.transparent : secondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: messageData.sent
                  ?  Icon(Icons.check, size: scrWidth * .022, color: Colors.white)
                  : Container(),
            )
          ],
        ),
      ),
    );
  }



}
