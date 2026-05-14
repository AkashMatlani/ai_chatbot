import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/message_model.dart';
import '../services/gemini_service.dart';

class ChatController extends GetxController {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController textController = TextEditingController();
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> sendMessage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final text = textController.text.trim();
    if (text.isEmpty) return;
    messages.add(MessageModel(text: text, isUser: true));
    textController.clear();
    isLoading.value = true;
    final response = await _geminiService.sendMessage(text);
    messages.add(MessageModel(text: response, isUser: false));
    isLoading.value = false;
  }
}
