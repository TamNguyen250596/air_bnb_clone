import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/item/base_item_model.dart';

class ImageItem extends StatefulWidget {
  // Init
  const ImageItem({super.key, required this.item});

  // Properties
  final BaseItemModel item;

  // Functions
  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          CachedNetworkImage(
            imageUrl: widget.item.imageUrl,
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(
              height: 5.0,
              width: 5.0,
              child: Center(child: CircularProgressIndicator()),
            ),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
          Text(
            widget.item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ]
      )
    );
  }
}
