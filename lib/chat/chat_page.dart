import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:third_step/chat/model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch(context)?.model;
    if (model == null) return const SizedBox.shrink();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 53, 92, 158),
        title: const _AppBarTitleWidget(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: const _MessagesWidget(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 50,
            right: 10,
            child: model.fAB
                ? FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 225, 231, 242),
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: () => model.scrollToBottom(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _AppBarTitleWidget extends StatelessWidget {
  const _AppBarTitleWidget();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: SizedBox(
              height: 45,
              width: 45,
              child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Image(image: AssetImage('images/ain.jpg')))),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Friend',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Scientist',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 198, 198, 198),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MessagesWidget extends StatelessWidget {
  const _MessagesWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch(context)?.model;
    if (model == null) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: ColoredBox(
            color: const Color.fromARGB(255, 202, 213, 234),
            child: StreamBuilder<QuerySnapshot>(
                stream: model.messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Something went wrong, try again later'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Loading...", style: TextStyle(fontSize: 24)),
                          SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  }

                  final data = snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return data;
                      })
                      .toList()
                      .reversed
                      .toList();

                  return ListView.builder(
                      reverse: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: model.scrollController,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var me = data[index]['uID'] == 1;
                        const radius = Radius.circular(18);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: me
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: me
                                      ? const Color.fromARGB(255, 169, 188, 221)
                                      : const Color.fromARGB(
                                          255, 228, 234, 244),
                                  borderRadius: BorderRadius.only(
                                    topLeft: radius,
                                    topRight: radius,
                                    bottomLeft: me ? radius : Radius.zero,
                                    bottomRight: me ? Radius.zero : radius,
                                  )),
                              child: Stack(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.sizeOf(context)
                                                          .width -
                                                      100),
                                          child: Text(
                                            data[index]['message'],
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 97, 94, 94)),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 3,
                                    child: Text(
                                      data[index]['time'].toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ),
        const _TextFieldAndActionsWidget(),
      ],
    );
  }
}

class _TextFieldAndActionsWidget extends StatelessWidget {
  const _TextFieldAndActionsWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sentiment_satisfied_alt_outlined)),
        Expanded(
          child: TextField(
            controller: model?.messageController,
            minLines: 1,
            maxLines: 6,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Сообщение',
            ),
            onChanged: (value) => model?.message = value,
          ),
        ),
        IconButton(
          onPressed: () => model?.saveMyFriendsMessage(context),
          icon: const Icon(Icons.attach_file),
        ),
        const _MicOrSendIcon(),
      ],
    );
  }
}

class _MicOrSendIcon extends StatelessWidget {
  const _MicOrSendIcon();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.watch(context)?.model;
    if (model == null) return const SizedBox.shrink();
    return model.messageController.text.trim().isEmpty
        ? IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mic),
          )
        : IconButton(
            onPressed: () => model.saveMessage(context),
            icon: const Icon(Icons.send),
          );
  }
}
