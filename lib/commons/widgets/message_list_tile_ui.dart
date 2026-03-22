import 'package:flutter/material.dart';

import '../../data/models/item/base_item_model.dart';

class MessageListTileUi extends StatelessWidget {
  const MessageListTileUi({
    super.key,
    required this.item,
  });

  final BaseItemModel item;

  bool get _isSent => item.tag == 'sent';

  Widget _avatar(BuildContext context) {
    final radius = MediaQuery.sizeOf(context).width / 20;
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        backgroundImage:
            item.imageUrl.isNotEmpty ? NetworkImage(item.imageUrl) : null,
        child: item.imageUrl.isEmpty
            ? Icon(
                Icons.person,
                size: radius,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              )
            : null,
      ),
    );
  }

  Widget _bubble(BuildContext context, {required Color backgroundColor}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
              ),
              textWidthBasis: TextWidthBasis.parent,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              item.des,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSent) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _bubble(
                  context,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),
            _avatar(context),
          ],
        ),
      );
    } else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _avatar(context),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _bubble(
                  context,
                  backgroundColor: Colors.green.withAlpha(55),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
