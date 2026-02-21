import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/commons/widgets/review_form.dart';
import 'package:air_bnb_clone/modules/guest/view_posting/view_posting_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/posting_info_item.dart';
import '../../../routing/route_id.dart';

class ViewPostingScreen extends StatefulWidget {
  const ViewPostingScreen({super.key});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {

  // Navigation
  Future<void> _navigateToBookPosting() async {
    final vm = context.read<ViewPostingViewModel>();
    // Pass a copy so BookPosting only mutates its own map; dates apply only when user taps "Book Now" and we pop with result.
    final Map<String, dynamic> extra = {
      "name": vm.name,
      "dates": Map<String, DateTime>.from(vm.bookingTimeMap),
    };

    final bookingTimeMap = await context.pushNamed<Map<String, DateTime>>(
      RouteConstant.bookPosting,
      extra: extra,
    );
    if (bookingTimeMap != null) {
      vm.updateBookingTimeMap(bookingTimeMap);
    }
  }

  // Content
  Widget _imagesHeaderView(BuildContext context) {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => AspectRatio(
        aspectRatio: 3 / 2,
        child: PageView.builder(
          itemCount: viewModel.displayImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: viewModel.displayImages[index],
                placeholder: (context, url) => SizedBox(
                  height: 10.0,
                  width: 10.0,
                  child: Center(child: CircularProgressIndicator()),
                ),
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      )
    );
  }

  Widget _title() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          viewModel.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _descriptionCard() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          viewModel.description,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
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
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _postingInfoTiles() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.postingInfoTiles.length,
        itemBuilder: (context, index) {
          final item = viewModel.postingInfoTiles[index];
          return PostingInfoTile(item: item);
        },
      ),
    );
  }

  Widget _amenitiesView() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: viewModel.amenities.map((amenity) {
          return Chip(
            label: Text(amenity, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green.withValues(alpha: 0.2),
          );
        }).toList(),
      ),
    );
  }

  Widget _locationView() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) {
        final center = viewModel.propertyLatLong;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.address,
              style: const TextStyle(color: Colors.white70),
            ),

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
                                onTap: () {
                                  viewModel.selectedMarker();
                                },
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
                if (viewModel.displayAddress.isNotEmpty)
                  Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        viewModel.displayAddress,
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

  Widget _hostCard() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) {
        final host = viewModel.posting.host!;
        return Container(
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
              Text(
                "Hosted by",
                style: const TextStyle(
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
              Text(viewModel.hostName),
            ],
          ),
        );
      },
    );
  }

  Widget _reviewSection() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) {
        return _sectionCard("Reviews", Column(children: [
          ReviewForm(
            initialRating: viewModel.reviewRating,
            onRatingChanged: viewModel.setReviewRating,
          ),
        ]));
      },
    );
  }

  Widget _bottomNavigationBar() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) {
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
                      viewModel.price,
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

                // Book Now button is only enabled for users who are NOT the host
                (!viewModel.isHost)
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _navigateToBookPosting();
                  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
                    : Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      appBar: CustomAppBar(title: "Posting Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            _imagesHeaderView(context),
            _title(),
            _descriptionCard(),

            _sectionCard("Details", _postingInfoTiles()),

            _sectionCard("Amenities", _amenitiesView()),

            _sectionCard("Location", _locationView()),

            _reviewSection(),

            _hostCard(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar()
    );
  }
}
