import 'package:air_bnb_clone/commons/widgets/rating_bar.dart';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/item/posting_grid_item_model.dart';
import '../constants/app_constants.dart';

class PostingGridItem extends StatefulWidget {
  const PostingGridItem({super.key, required this.item});

  final PostingGridItemModel item;

  @override
  State<PostingGridItem> createState() => _PostingGridItemState();
}

class _PostingGridItemState extends State<PostingGridItem> {
  // Content
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: (widget.item.imageUrl.isEmpty)
              ? Container()
              : CachedNetworkImage(
                  imageUrl: widget.item.imageUrl,
                  placeholder: (context, url) => SizedBox(
                    height: 5.0,
                    width: 5.0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  fit: BoxFit.contain,
                ),
        ),

        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.item.des,
                maxLines: 1,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                widget.item.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              RatingBar.readOnly(
                size: 28.0,
                maxRating: 5,
                initialRating: widget.item.rating,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                filledColor: AppConstants.selectedIcon,
                isHalfAllowed: true,
                halfFilledIcon: Icons.star_half,
                halfFilledColor: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                widget.item.ratingStr,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
