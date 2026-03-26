import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/commons/widgets/reviews_section_card.dart';
import 'package:air_bnb_clone/modules/guest/view_posting/view_posting_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/posting_info_item.dart';
import '../../../routing/route_id.dart';

class ViewPostingScreen extends StatelessWidget {
  // ========== Constructor ==========
  const ViewPostingScreen({super.key});

  // ========== Navigation ==========
  Future<void> _navigateToBookPosting(BuildContext context) async {
    final cubit = context.read<ViewPostingCubit>();
    final state = cubit.state;
    final Map<String, dynamic> extra = {
      "name": state.name,
      "dates": Map<String, DateTime>.from(state.bookingTimeMap),
      "posting": cubit.posting,
    };

    final bookingTimeMap = await context.pushNamed<Map<String, DateTime>>(
      RouteConstant.bookPosting,
      extra: extra,
    );
    if (bookingTimeMap != null) {
      cubit.updateBookingTimeMap(bookingTimeMap);
    }
  }

  void _navigateToViewReview(BuildContext context) {
    final cubit = context.read<ViewPostingCubit>();
    final posting = cubit.posting;
    if (!posting.isValid) return;
    final Map<String, dynamic> extra = {
      "targetType": "posting",
      "targetId": posting.id,
    };
    context.pushNamed(RouteConstant.viewReview, extra: extra);
  }

  void _navigateToViewProfile(BuildContext context) {
    final cubit = context.read<ViewPostingCubit>();
    final host = cubit.posting.host;
    final canReview = cubit.state.canReview;
    if (host == null || !host.isValid) return;
    final Map<String, dynamic> extra = {
      "host": host,
      "canReview": canReview,
    };
    context.pushNamed(RouteConstant.viewProfile, extra: extra);
  }

  // ========== Content ==========
  Widget _appBarAction() {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => !state.isHost
          ? IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: state.isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                context.read<ViewPostingCubit>().toggleFavourite();
              },
            )
          : Container(),
    );
  }

  Widget _imagesHeaderView(BuildContext context) {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => AspectRatio(
        aspectRatio: 3 / 2,
        child: PageView.builder(
          itemCount: state.displayImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: state.displayImages[index],
                placeholder: (context, url) => const SizedBox(
                  height: 10.0,
                  width: 10.0,
                  child: Center(child: CircularProgressIndicator()),
                ),
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _title() {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          state.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _descriptionCard() {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          state.description,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _sectionCard(String title, Widget child, {Widget? rightButton}) {
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
              if (rightButton != null) rightButton,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _postingInfoTiles() {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.postingInfoTiles.length,
        itemBuilder: (context, index) {
          final item = state.postingInfoTiles[index];
          return PostingInfoTile(item: item);
        },
      ),
    );
  }

  Widget _amenitiesView() {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: state.amenities.map((amenity) {
          return Chip(
            label: Text(amenity, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green.withValues(alpha: 0.2),
          );
        }).toList(),
      ),
    );
  }

  Widget _locationView(BuildContext context) {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) {
        final center = state.propertyLatLong;
        final cubit = context.read<ViewPostingCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.address, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Stack(
              children: [
                SizedBox(
                  height: 201,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 15,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.air_bnb_clone',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: center,
                              width: 48,
                              height: 48,
                              child: GestureDetector(
                                onTap: () => cubit.selectedMarker(),
                                child: Image.asset(
                                  'assets/images/house.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.displayAddress.isNotEmpty)
                  Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        state.displayAddress,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _hostCard(BuildContext context) {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) {
        final host = context.read<ViewPostingCubit>().posting.host;
        if (host == null) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => _navigateToViewProfile(context),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Hosted by",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: host.imageUrl ?? '',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      width: 70,
                      height: 70,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[800],
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(state.hostName),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _reviewSection(BuildContext context) {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
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
                context.read<ViewPostingCubit>().setReviewRating(v),
            onSubmitted: (comment) =>
                context.read<ViewPostingCubit>().submitReview(comment),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BlocBuilder<ViewPostingCubit, ViewPostingState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "/ day",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                (!state.isHost)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _navigateToBookPosting(context),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Cannot Book Your Own Posting",
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Posting Details",
        actions: [_appBarAction()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            _imagesHeaderView(context),
            _title(),
            _descriptionCard(),
            _sectionCard("Details", _postingInfoTiles()),
            _sectionCard("Amenities", _amenitiesView()),
            _sectionCard("Location", _locationView(context)),
            _reviewSection(context),
            _hostCard(context),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }
}
