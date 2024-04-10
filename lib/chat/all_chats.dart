import 'package:flutter/material.dart';
import 'package:third_step/chat/model.dart';

class AllChats extends StatelessWidget {
  const AllChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 53, 92, 158),
          centerTitle: true,
          title: const Text(
            'Chats',
            style: TextStyle(color: Colors.white),
          )),
      body: Column(
        children: [
          TextButton(
              onPressed: () => model?.toChatPage(context),
              child: const _RowChatInfoWidget()),
          const Divider(
            height: 2,
          )
        ],
      ),
    );
  }
}

class _RowChatInfoWidget extends StatelessWidget {
  const _RowChatInfoWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch(context)?.model;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: SizedBox(
              height: 60,
              width: 60,
              child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Image(image: AssetImage('images/ain.jpg')))),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Friend',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            Text(
              model?.lastMessage ?? '',
              style: const TextStyle(color: Color.fromARGB(255, 93, 93, 93)),
            ),
          ],
        ),
      ],
    );
  }
}
