import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/message_list_tile_ui.dart';
import 'chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // Properties
  final TextEditingController _controller = TextEditingController();

  // Life cycle
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Functions
  void _sendMessage() {
    context.read<ChatCubit>().sendMessage(_controller.text);
    _controller.clear();
  }

  Widget _messagesList(ChatState state) {
    if (state.isLoading && state.messages.isEmpty) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.messages.length,
        itemBuilder: (context, index) =>
            MessageListTileUi(item: state.messages[index]),
      ),
    );
  }

  Widget _messageInputRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28, left: 6, right: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 5 / 6,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Write a message',
                  contentPadding: EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
                style: const TextStyle(fontSize: 20),
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, size: 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: state.conversationName.isEmpty ? 'Chat' : state.conversationName),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _messagesList(state),
                _messageInputRow(),
              ],
            ),
          );
        },
      );
  }
}
