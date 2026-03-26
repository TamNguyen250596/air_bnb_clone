import 'package:air_bnb_clone/data/models/item/review_item_model.dart';
import 'package:flutter/material.dart';

import 'review_form.dart';
import 'review_item.dart';

/// Section card with a title row, optional trailing action, and [child] body.
/// Matches the styling used for the posting details "Reviews" block.
class ReviewsSectionCard extends StatelessWidget {
  const ReviewsSectionCard({
    super.key,
    this.title = 'Reviews',
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Chevron [IconButton] for the reviews section title row; [onPressed] is forwarded as-is.
class ReviewsSectionForwardIconButton extends StatelessWidget {
  const ReviewsSectionForwardIconButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_forward_ios),
      onPressed: onPressed,
    );
  }
}

/// Review form (or locked message) plus a scroll-safe list of [ReviewItem] rows.
class ReviewsSectionContent extends StatelessWidget {
  const ReviewsSectionContent({
    super.key,
    required this.canReview,
    required this.reviewRating,
    required this.recentReviews,
    required this.onRatingChanged,
    required this.onSubmitted,
  });

  final bool canReview;
  final double reviewRating;
  final List<ReviewItemModel> recentReviews;
  final ValueChanged<double> onRatingChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (canReview)
          ReviewForm(
            initialRating: reviewRating,
            onRatingChanged: onRatingChanged,
            onSubmitted: onSubmitted,
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "You can submit a review only if you booked this posting.",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        _RecentReviewsList(items: recentReviews),
      ],
    );
  }
}

class _RecentReviewsList extends StatelessWidget {
  const _RecentReviewsList({required this.items});

  final List<ReviewItemModel> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ReviewItem(item: items[index]),
            );
          },
        ),
      ],
    );
  }
}
