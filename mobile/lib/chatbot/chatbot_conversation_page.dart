import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:mental_health_app/chatbot/chatbot_model.dart';

class ChatbotConversationPage extends ConsumerStatefulWidget {
  const ChatbotConversationPage({super.key});

  @override
  ConsumerState<ChatbotConversationPage> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatbotConversationPage> {
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

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Message>> messages = ref.watch(chatbotModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot page"),
        backgroundColor: Colors.grey.shade100,
      ),
      drawer: const AppDrawer(),
      body: GestureDetector(
        onTap: _focusNode.unfocus,
        child: Column(
          children: [
            Expanded(
              child: switch (messages) {
                AsyncData(:final value) => Builder(
                    builder: (context) {
                      List<Widget> children = [];

                      for (int i = 0; i < value.length; i++) {
                        final Message message = value[value.length - i - 1];
                        children.add(MessageWidget(message: message));

                        if (i != value.length - 1 && !message.fromChatBot) {
                          children.add(
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                          );
                        }
                      }

                      return ListView(
                        reverse: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        controller: _scrollController,
                        children: children,
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

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: (message.fromChatBot
            ? Alignment.centerLeft
            : Alignment.centerRight),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: message.fromChatBot
                ? Colors.transparent
                : const Color.fromARGB(180, 195, 199, 195),
          ),
          child: Text(message.message),
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
  bool empty = true;

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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // color: Colors.grey.shade400,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Container(
        // width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextField(
          textAlignVertical:
              _textController.text.isNotEmpty ? TextAlignVertical.center : null,
          controller: _textController,
          scrollPadding: EdgeInsets.all(4.0),
          focusNode: _focusNode,
          minLines: 1,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            suffixIcon: _textController.text.isNotEmpty
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
                      }
                    },
                    icon: const Icon(
                      IconData(0xf57e, fontFamily: 'MaterialIcons'),
                    ),
                  )
                : null,
            border: InputBorder.none,
            hintText: "Message",
            filled: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          ),
          onChanged: (s) => setState(() {}),
        ),
      ),
    );
  }
}
