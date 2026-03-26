import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/modules/guest/view_review/view_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/widgets/review_item.dart';

class ViewReviewScreen extends StatelessWidget {

  // Construct
  const ViewReviewScreen({super.key});

  // Content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Reviews"),
      body: BlocBuilder<ViewReviewCubit, ViewReviewState>(
        builder: (context, state) => ListView.separated(
          shrinkWrap: true,
          itemCount: state.reviews.length,
          separatorBuilder: (context, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ReviewItem(item: state.reviews[index]),
            );
          },
        )
      )
    );
  }
}
