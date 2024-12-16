import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:mental_health_app/chatbot/chatbot_model.dart';

class ChatBotPage extends ConsumerStatefulWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBotPage> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Message>> messages = ref.watch(chatbotModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot page"),
      ),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: _focusNode.unfocus,
        child: Column(
          children: [
            Expanded(
              child: switch (messages) {
                AsyncData(:final value) => ListView.builder(
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: _scrollController,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final message = value[value.length - index - 1];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Align(
                          alignment: (message.fromChatBot
                              ? Alignment.centerLeft
                              : Alignment.centerRight),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: message.fromChatBot
                                  ? const Color.fromARGB(255, 160, 205, 243)
                                  : const Color.fromARGB(255, 166, 240, 168),
                            ),
                            child: Text(message.message),
                          ),
                        ),
                      );
                    },
                  ),
                AsyncError() =>
                  const Text('Oops, something unexpected happened'),
                _ => const CircularProgressIndicator(),
              },
            ),
            _TextAreaWidgetState(),
          ],
        ),
      ),
    );
  }
}

class _TextAreaWidgetState extends ConsumerStatefulWidget {
  const _TextAreaWidgetState({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __TextAreaWidgetStateState();
}

class __TextAreaWidgetStateState extends ConsumerState<_TextAreaWidgetState> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 30,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                controller: _textController,
                scrollPadding: EdgeInsets.all(4.0),
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                    hintText: "send message",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0)),
                onChanged: (s) => setState(() {}),
              ),
            ),
            SizedBox(
              width: 30,
              child: _textController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        String message = _textController.text.trim();
                        if (message.isNotEmpty) {
                          ref
                              .read(chatbotModelProvider.notifier)
                              .addUserMessage(message);
                          _textController.clear();
                          _focusNode.unfocus();
                          _scrollToBottom();
                          // setState(() {

                          // });
                        }
                      },
                      icon: Icon(IconData(0xf57e, fontFamily: 'MaterialIcons')))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
