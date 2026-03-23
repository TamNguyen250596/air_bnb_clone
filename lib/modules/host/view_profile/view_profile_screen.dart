import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/commons/widgets/reviews_section_card.dart';
import 'package:air_bnb_clone/routing/route_id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'view_profile_cubit.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  void _navigateToViewReview(BuildContext context) {
    final state = context.read<ViewProfileCubit>().state;
    if (state.hostId.isEmpty) return;
    final extra = {"targetType": "user", "targetId": state.hostId};
    context.pushNamed(RouteConstant.viewReview, extra: extra);
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _profileHeader() {
    return BlocBuilder<ViewProfileCubit, ViewProfileState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Hello, My name is ${state.greetingName}',
                style: const TextStyle(fontSize: 25),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: MediaQuery.of(context).size.width / 9.5,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 10,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: state.imageUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 42,
                          color: Colors.black54,
                        )
                      : CachedNetworkImage(
                          imageUrl: state.imageUrl,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          fit: BoxFit.cover,
                          errorWidget: (context, _, __) => const Icon(
                            Icons.person,
                            size: 42,
                            color: Colors.black54,
                          ),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _aboutMe() {
    return BlocBuilder<ViewProfileCubit, ViewProfileState>(
      builder: (context, state) {
        return Text(state.bio, style: const TextStyle(fontSize: 20));
      },
    );
  }

  Widget _location() {
    return BlocBuilder<ViewProfileCubit, ViewProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.home),
              const SizedBox(width: 15),
              Text('Lives in ${state.location}'),
            ],
          ),
        );
      },
    );
  }

  Widget _reviewSection(BuildContext context) {
    return BlocBuilder<ViewProfileCubit, ViewProfileState>(
      builder: (context, state) {
        return ReviewsSectionCard(
          trailing: ReviewsSectionForwardIconButton(
            onPressed: () => _navigateToViewReview(context),
          ),
          child: ReviewsSectionContent(
            canReview: state.canReview,
            reviewRating: state.reviewRating,
            recentReviews: state.recentReviews,
            onRatingChanged: (v) =>
                context.read<ViewProfileCubit>().setReviewRating(v),
            onSubmitted: (comment) =>
                context.read<ViewProfileCubit>().submitReview(comment),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'View Profile'),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  _profileHeader(),
                  _sectionTitle('About Me'),
                  _aboutMe(),
                  _sectionTitle('Location'),
                  _location(),
                ],
              ),
            ),
            _reviewSection(context),
          ],
        ),
      ),
    );
  }
}
