import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:flutter/material.dart';

class PostingInfoTile extends StatelessWidget {
  final BaseItemModel item;

  const PostingInfoTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.imageData, size: 30, color: Colors.green),
      title: Text(
        item.title,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      subtitle: Text(
        item.des,
        style: const TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}