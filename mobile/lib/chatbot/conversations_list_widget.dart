import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/chatbot/conversation_list_provider.dart';

class ConversationsListWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _ConversationListState();
  }
}

class _ConversationListState extends ConsumerState<ConversationsListWidget> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(conversationListProvider).when(
        data: (data) => ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    ref.read(conversationListProvider.notifier).redirectToConvo(data[index]);
                  },
                  child: Text(data[index].name),
                );
              },
            ),
        error: (error, stack) => Builder(
          builder: (context) {
            print("$error, $stack");
            return Text(
                "There has been an error when fetching past conversattions $error $stack");
          }
        ),
        loading: () =>
            const Text("Please wait until past conversations fully load"));
  }
}
