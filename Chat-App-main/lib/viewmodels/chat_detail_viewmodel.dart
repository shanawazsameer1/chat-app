import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatDetailViewModel extends ChangeNotifier {
  List<MessageModel> messages = [];
  bool isLoading = true;

  void loadMessages(String chatId) {
    isLoading = true;
    notifyListeners();
    
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      // Load dummy messages for demo
      messages = _getDummyMessages();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    // Add message to local list (demo functionality)
    messages.insert(0, message); // Insert at top for reverse list
    notifyListeners();
  }

  List<MessageModel> _getDummyMessages() {
    final now = DateTime.now();
    return [
      MessageModel(
        id: '1',
        senderId: 'other_user',
        receiverId: 'my_uid',
        text: 'Hey! How are you doing? 😊',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '2',
        senderId: 'my_uid',
        receiverId: 'other_user',
        text: 'Hi there! I\'m doing great, thanks for asking! How about you?',
        timestamp: now.subtract(const Duration(minutes: 4)),
        seen: true, // This message was seen
      ),
      MessageModel(
        id: '3',
        senderId: 'other_user',
        receiverId: 'my_uid',
        text: 'I\'m doing well too! Just working on some exciting projects 🚀',
        timestamp: now.subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        id: '4',
        senderId: 'my_uid',
        receiverId: 'other_user',
        text: 'That sounds awesome! What kind of projects are you working on?',
        timestamp: now.subtract(const Duration(minutes: 2)),
        seen: true, // This message was seen
      ),
      MessageModel(
        id: '5',
        senderId: 'other_user',
        receiverId: 'my_uid',
        text: 'Flutter apps mostly! Building some really cool chat interfaces 💬',
        timestamp: now.subtract(const Duration(minutes: 1)),
      ),
      MessageModel(
        id: '6',
        senderId: 'my_uid',
        receiverId: 'other_user',
        text: 'That\'s amazing! I love working with Flutter too. The UI possibilities are endless! 🎨',
        timestamp: now.subtract(const Duration(seconds: 30)),
        seen: false, // Latest message not seen yet
      ),
    ].reversed.toList(); // Reverse for proper chat order (oldest first)
  }
}
