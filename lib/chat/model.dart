import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:third_step/chat/chat_page.dart';

class Model extends ChangeNotifier {
  Model() {
    messageController.addListener(() {
      toggleFAB();
      toggleIcons();
    });
    scrollController.addListener(() => toggleFAB());
    initialBottomPosition();
  }

  var message = '';
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final db = FirebaseFirestore.instance;
  // var isKeyBoardVisible = false;
  var isTextEmpty = true;
  var fAB = false;

  void toggleFAB() {
    if (scrollController.position.atEdge && scrollController.offset == 0 ||
        messageController.text.length > 20) {
      fAB = false;
      notifyListeners();
    } else {
      fAB = true;
      notifyListeners();
    }
  }

  void toggleIcons() {
    if (messageController.text.trim().isNotEmpty) {
      isTextEmpty = false;
      notifyListeners();
    } else {
      isTextEmpty = true;
      notifyListeners();
    }
  }

  final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
      .collection('chatWithMyFriend')
      .orderBy('timestamp')
      .snapshots();

  final timeStamp = DateTime.now().toString().substring(10, 16);

  void saveMessage(BuildContext context) {
    if (message.trim().isEmpty) return;
    final chatMessage = <String, dynamic>{
      "message": message.trim(),
      "time": timeStamp,
      "timestamp": DateTime.now(),
      "uID": 1,
    };
    db.collection("chatWithMyFriend").add(chatMessage);
    messageController.clear();
    scrollToBottom();
  }

  void saveMyFriendsMessage(BuildContext context) {
    if (message.trim().isEmpty) return;
    final chatMessage = <String, dynamic>{
      "message": message.trim(),
      "time": timeStamp,
      "timestamp": DateTime.now(),
      "uID": 0,
    };
    db.collection("chatWithMyFriend").add(chatMessage);
    messageController.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    } else {
      Timer(const Duration(), () => scrollToBottom());
    }
  }

  void initialBottomPosition() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
      notifyListeners();
    } else {
      Timer(const Duration(), () => initialBottomPosition());
    }
  }

  void toChatPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ChatPage(),
      ),
    );
    initialBottomPosition();
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }
}

class ModelProvider extends InheritedNotifier {
  final Model model;
  const ModelProvider({
    super.key,
    required super.child,
    required this.model,
  }) : super(
          notifier: model,
        );

  static ModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModelProvider>();
  }

  static ModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ModelProvider>()
        ?.widget;
    return widget is ModelProvider ? widget : null;
  }
}
