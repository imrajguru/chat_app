import 'package:hive/hive.dart';
import '../models/message_model.dart';

class ChatStorageService {
  static const String _boxName = 'chat_history';

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final box = await Hive.openBox(_boxName);
    final data = messages.map((m) => m.toMap()).toList();
    await box.put('messages', data);
  }

  Future<List<ChatMessage>> loadMessages() async {
    final box = await Hive.openBox(_boxName);
    final data = box.get('messages', defaultValue: []);

    return List<Map<String, dynamic>>.from(data)
        .map((e) => ChatMessage.fromMap(e))
        .toList();
  }

  Future<void> clearMessages() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }
}
