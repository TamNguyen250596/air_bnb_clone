import 'package:air_bnb_clone/commons/widgets/rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/item/posting_grid_item_model.dart';
import '../constants/app_constants.dart';

class PostingGridItem extends StatelessWidget {
  const PostingGridItem({
    super.key,
    required this.item,
    this.onClearPressed,
  });

  final PostingGridItemModel item;
  final VoidCallback? onClearPressed;

  @override
  Widget build(BuildContext context) {
    final onClear = onClearPressed;
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        _buildBody(),
        if (onClear != null)
        _buildClearButton(onClear)
      ],
    );
  }

  Widget _buildClearButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 30,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.clear, color: Colors.white),
        ),
      )
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        _buildTexts(),
        _buildRatingRow(),
      ],
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: item.imageUrl.isEmpty
          ? const SizedBox.shrink()
          : CachedNetworkImage(
              imageUrl: item.imageUrl,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildTexts() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.des,
            maxLines: 1,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            item.price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          RatingBar.readOnly(
            size: 28.0,
            maxRating: 5,
            initialRating: item.rating,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            filledColor: AppConstants.selectedIcon,
            isHalfAllowed: true,
            halfFilledIcon: Icons.star_half,
            halfFilledColor: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            item.ratingStr,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
