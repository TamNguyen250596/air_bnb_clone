import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/modules/guest/view_posting/view_posting_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/posting_info_item.dart';

class ViewPostingScreen extends StatefulWidget {
  const ViewPostingScreen({super.key});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {
  // Content
  Widget _imageHeaderView(BuildContext context) {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => CachedNetworkImage(
        imageUrl: viewModel.imageUrl,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 2 / 3,
        placeholder: (context, url) => SizedBox(
          height: 10.0,
          width: 10.0,
          child: Center(child: CircularProgressIndicator()),
        ),
        fit: BoxFit.contain,
      ),
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
            label: Text(
              amenity,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green.withValues(alpha: 0.2),
          );
        }).toList(),
      )
    );
  }

  Widget _locationView() {
    return Consumer<ViewPostingViewModel>(
      builder: (context, viewModel, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.address,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Posting Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            _imageHeaderView(context),
            _title(),
            _descriptionCard(),

            _sectionCard(
              "Details",
              _postingInfoTiles(),
            ),

            _sectionCard(
              "Amenities",
              _amenitiesView(),
            ),

            _sectionCard(
              "Location",
              _locationView(),
            ),

            // Reviews
            _sectionCard(
              "Reviews",
              Column(children: []),
            ),

            _hostCard(),
          ],
        ),
      ),
    );
  }
}
