import 'package:air_bnb_clone/commons/widgets/image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../data/models/realm_models/conversation/conversation.dart';
import '../../../routing/route_id.dart';
import 'inbox_cubit.dart';

class InboxScreen extends StatelessWidget {

  // Constructor
  const InboxScreen({super.key});

  // Navigation
  void navigateInboxToChat(BuildContext context, Conversation conversation) {
    final location = GoRouterState.of(context).matchedLocation;
    final base = location.contains(RouteConstant.hostInbox)
        ? RouteConstant.hostInboxPath
        : RouteConstant.inboxPath;
    context.push('$base/${RouteConstant.chat}', extra: conversation);
  }

  // Content
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Inbox'),
          body: Padding(
            padding: const EdgeInsets.only(top: 23),
            child: ListView.builder(
                itemCount: state.conversations.length,
                itemExtent: MediaQuery.of(context).size.height / 9,
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];

                  return InkResponse(
                    onTap: () {
                      final conv = context
                          .read<InboxCubit>()
                          .conversationFor(conversation);
                      if (conv != null) {
                        navigateInboxToChat(context, conv);
                      }
                    },
                    child: ImageItem(item: conversation)
                  );
                }
            ),
          ),
        );
      }
    );
  }
}
