import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterquiz/app/app_localization.dart';
import 'package:flutterquiz/ui/screens/chat/cubit/chatCubit.dart';
import 'package:flutterquiz/ui/screens/chat/model/messageModel.dart';
import 'package:flutterquiz/ui/screens/chat/widget/myMessage.dart';
import 'package:flutterquiz/ui/screens/chat/widget/othersMessage.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/circularImage.dart';
import 'package:flutterquiz/ui/widgets/circularImageContainer.dart';
import 'package:flutterquiz/ui/widgets/circularProgressContainer.dart';
import 'package:flutterquiz/ui/widgets/customAppbar.dart';
import 'package:flutterquiz/ui/widgets/errorContainer.dart';
import 'package:flutterquiz/utils/constants/error_message_keys.dart';
import 'package:flutterquiz/utils/constants/fonts.dart';
import 'package:flutterquiz/utils/ui_utils.dart';
import 'package:flutterquiz/utils/user_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  String userName;
  String userId;
  String userProfileImage;

  ChatScreen(
      {super.key,
      required this.userName,
      required this.userId,
      required this.userProfileImage});

  static Route<dynamic> route(RouteSettings routeSettings) {
    Map arguments = routeSettings.arguments as Map;

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => ChatCubit(),
        child: ChatScreen(
          userName: arguments['userName'],
          userId: arguments['userId'],
          userProfileImage: arguments['userProfileUrl'],
        ),
      ),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();

  // Screen dimensions
  double get scrWidth => MediaQuery.of(context).size.width;

  // HomeScreen horizontal margin, change from here
  double get hzMargin => scrWidth * UiUtils.hzMarginPct;
  get _statusBarPadding => MediaQuery.of(context).padding.top;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ChatCubit>().fetchMoreMessages();
    }
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    // final ChatCubit chatCubit = BlocProvider.of<ChatCubit>(context);
    return Scaffold(
      appBar: const QAppBar(
        title: Text("CeMAP Group"),
      ),
      body: Column(
        children: [_chatMessageList(), _buildTextField()],
      ),
    );
  }

  Widget _chatMessageList() {
    return Expanded(
      child: BlocBuilder<ChatCubit, List<MessageModel>>(
        builder: (context, messages) {
         

          if (messages.isEmpty) {
            // Data is still loading or empty
            return const Center(child: Text("Loading..."));
          } else {
            return ListView.builder(
              itemCount: messages.length,
              controller: _scrollController,
              reverse: true,
              itemBuilder: (context, index) {
                final messageData = messages[index];
                final prevMessageUserId = index + 1 == messages.length
                    ? messageData.senderId
                    : index + 1 < messages.length
                        ? messages[index + 1].senderId
                        : null;
                final nextMessageUserId =
                    (index - 1) >= 0 && (index - 1) < messages.length
                        ? messages[index - 1].senderId
                        : null;

                if (messageData.senderId == widget.userId) {
                  return MyMessage(
                    key: ValueKey(messageData.messageId),
                    hzMargin: hzMargin,
                    prevMessageUserId: prevMessageUserId,
                    nextMessageUserId: nextMessageUserId,
                    messageData: messageData,
                    onLongPress: () => handleDelete(context, messageData),
                  );
                } else {
                  return OthersMessage(
                    key: ValueKey(messageData.messageId),
                    hzMargin: hzMargin,
                    prevMessageUserId: prevMessageUserId,
                    nextMessageUserId: nextMessageUserId,
                    messageData: messageData,
                  );
                }
              },
            );
          }
        },
      ),
    );
  }


  Widget _buildTextField() {
    return Padding(
      padding: EdgeInsets.all(hzMargin),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: "Type...",
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    // borderSide: BorderSide(color: const Color.fromARGB(255, 142, 142, 142)..withOpacity(.4),width:1),
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              style: TextStyle(color: Colors.black.withOpacity(.8)),

              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ),
           SizedBox(width: scrWidth * .01),
          IconButton(
            onPressed: handleSendMessage,
            icon: const Icon(
              Icons.send,
              size: 30,
              color:secondaryColor
            ),
          )
        ],
      ),
    );
  }

  void handleSendMessage() {
    if (textController.text.trim().isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      });
      MessageModel messageData = MessageModel(
          textController.text.trim(),
          widget.userId,
          widget.userProfileImage,
          widget.userName,
          '',
          false,
          false,
          false,
          DateTime.now());
      textController.clear();
      context.read<ChatCubit>().sendMessage(messageModel: messageData);

      // TestMessage().sendMessage(messageModel: messageData);
    }
  }

  Future<void> handleDelete(
      BuildContext context, MessageModel messageData) async {
    // Show a delete confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
         
          title: const Text('Unsent Message'),
          content: const Text('Are you sure you want unsent this message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel' ,style:TextStyle(color: onBackgroundColor),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                context.read<ChatCubit>().unsentMessage(messageData.messageId);
              },
              child: const Text('unsent', style: TextStyle(color: hurryUpTimerColor),),
            ),
          ],
        );
      },
    );
  }
}
