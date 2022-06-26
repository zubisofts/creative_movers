import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/chat_message_request.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageItem extends StatefulWidget {
  const MessageItem(
      {Key? key,
      required this.chatMessage,
      this.shouldLoad = false,
      required this.onMessageSent,
      required this.onDeleteMessage,
        required this.otherUserId})
      : super(key: key);
  final Message chatMessage;
  final bool? shouldLoad;
  final int otherUserId;
  final Function(Message) onMessageSent;
  final Function(Message) onDeleteMessage;

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();
  final ChatBloc _chatBloc = ChatBloc(injector.get());
  bool? _shouldLoad;

  @override
  void initState() {
    super.initState();
    _cacheCubit.fetchCachedUserData();
    _shouldLoad = widget.shouldLoad;
    if (_shouldLoad != null) {
      log("SHOULD LOAD: ${widget.chatMessage.shouldLoad}");
      if (_shouldLoad!) {
        if(widget.chatMessage.conversationId == "-1"){
          _chatBloc.add(SendChatMessage(
              message: ChatMessageRequest(
                  userId: int.parse(widget.chatMessage.userId),
                  message: widget.chatMessage.body!)));
        }else {
          _chatBloc.add(SendChatMessage(
              message: ChatMessageRequest(
                  userId: int.parse(widget.chatMessage.userId),
                  conversationId: int.parse(widget.chatMessage.conversationId),
                  message: widget.chatMessage.body!)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    bool isForMe = widget.chatMessage.userId == cachedUser.id.toString();
    log("IS FORMW: $isForMe");
    return Column(
      crossAxisAlignment:
          !isForMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: !isForMe
              ? EdgeInsets.only(
                  left: 12, right: MediaQuery.of(context).size.width * 0.15)
              : EdgeInsets.only(
                  right: 12, left: MediaQuery.of(context).size.width * 0.15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                child: CircleImage(
                  url: widget.chatMessage.profilePhotoPath,
                  withBaseUrl: false,
                  radius: 18,
                ),
                visible: !isForMe,
              ),
              Flexible(
                child: Visibility(
                  visible: widget.chatMessage.media.isEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: !isForMe
                            ? Colors.grey.shade300
                            : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '${widget.chatMessage.body}',
                      style: TextStyle(
                          color: !isForMe
                              ? AppColors.PtextColor
                              : AppColors.white),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.chatMessage.media.isNotEmpty,
                child: Container(
                  height: 200,
                  width: 170,
                  margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
                  decoration: BoxDecoration(
                      // gradient: const RadialGradient(
                      //   colors: [
                      //     AppColors.gradient,
                      //     AppColors.gradient2,
                      //   ],
                      //   radius: 0.8,
                      // ),
                      color: AppColors.primaryColor,
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.5), BlendMode.srcOver),
                          fit: BoxFit.cover,
                          image: const NetworkImage(
                            'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                          )),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Icon(
                      Icons.videocam_off_rounded,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: widget.chatMessage.media.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 220,
                      width: 170,
                      margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.grey.withOpacity(0.5),
                                  BlendMode.srcOver),
                              fit: BoxFit.cover,
                              image: const NetworkImage(
                                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
                              )),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Icon(
                          Icons.photo_camera_rounded,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        BlocConsumer<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is ChatMessageSent) {
              widget.onMessageSent(state.chatMessageResponse.chatData.message);
            }
            if (state is ChatError) {
              setState(() {
                _shouldLoad = false;
              });
            }
          },
          builder: (context, state) {
            if (state is ChatMessageLoading) {
              return const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'Sending...',
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              );
            }
            if (state is ChatError) {
              return GestureDetector(
                onTap: () {
                  if (_shouldLoad!) {
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: const Border.fromBorderSide(
                        BorderSide(
                          width: 0.5,
                          color: AppColors.grey,
                        ),
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.refresh,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Retry',
                        style: TextStyle(color: AppColors.red),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is ChatMessageSent) {
              return Padding(
                padding: isForMe
                    ? const EdgeInsets.only(right: 16)
                    : const EdgeInsets.only(left: 50),
                child: Text(
                  AppUtils.getTime(widget.chatMessage.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            }
            return Padding(
              padding: isForMe
                  ? const EdgeInsets.only(right: 16)
                  : const EdgeInsets.only(left: 50),
              child: Text(
                AppUtils.getTime(widget.chatMessage.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        ),
      ],
    );
  }
}
