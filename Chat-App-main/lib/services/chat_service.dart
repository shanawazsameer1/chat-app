import 'package:firebase_database/firebase_database.dart';
import '../models/message_model.dart';

class ChatService {
  final _db = FirebaseDatabase.instance.reference();

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db.child('chats/$chatId/messages').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.values.map((e) => MessageModel.fromMap(Map<String, dynamic>.from(e))).toList();
    });
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    await _db.child('chats/$chatId/messages/${message.id}').set(message.toMap());
  }
}
