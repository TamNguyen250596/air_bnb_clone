import 'package:air_bnb_clone/commons/widgets/rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/item/review_item_model.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({super.key, required this.item});

  final ReviewItemModel item;

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final url = widget.item.imageUrl.trim();
    final radius = MediaQuery.sizeOf(context).width / 15;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[800],
          backgroundImage: url.isNotEmpty
              ? CachedNetworkImageProvider(url)
              : null,
          child: url.isEmpty
              ? Icon(Icons.person, size: radius, color: Colors.white70)
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              RatingBar.readOnly(
                size: 30,
                maxRating: 5,
                initialRating: widget.item.rating,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                isHalfAllowed: true,
                filledColor: Colors.green,
                halfFilledColor: Colors.green,
              ),
              if (widget.item.des.isNotEmpty) _expandableComment(widget.item.des),
            ],
          ),
        ),
      ],
    );
  }

  Widget _expandableComment(String text) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white70),
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;
        final lineHeight = textPainter.preferredLineHeight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : BoxConstraints(maxHeight: lineHeight * 2),
                child: Text(
                  text,
                  maxLines: _expanded ? null : 2,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'See less' : 'See more',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
