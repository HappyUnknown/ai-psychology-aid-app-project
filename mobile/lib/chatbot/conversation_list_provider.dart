import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/chatbot/chatbot_model.dart';
import 'package:mental_health_app/chatbot/conversation_model.dart';
import 'package:mental_health_app/repository/chatbot_conversation_repository.dart';
import 'package:mental_health_app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'conversation_list_provider.g.dart';

@riverpod
class ConversationList extends _$ConversationList {
  final _conversationRepo = ChatbotConversationRepository();
  @override
  Future<List<ConversationDataModel>> build() {
    return _getList();
  }

  Future<List<ConversationDataModel>> _getList() async {
    QuerySnapshot query = await _conversationRepo.getConversations(
        uid: ref.read(currentUidProvider));

    final List<ConversationDataModel> converstations = query.docs
        .map((e) => ConversationDataModel.fromQueryDocSnapshot(e))
        .toList();

    return converstations;
  }


  Future<void> redirectToConvo(ConversationDataModel model) async {
    ref.read(chatbotModelProvider.notifier).getFromConversationRef(model);
  
  }
}
