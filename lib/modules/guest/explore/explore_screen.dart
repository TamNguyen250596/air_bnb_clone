import 'package:air_bnb_clone/modules/guest/explore/explore_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/posting_grid_item.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../routing/route_id.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Navigation
  void _navigateToViewPostingPage(Posting posting) {
    context.pushNamed(RouteConstant.viewPosting, extra: posting);
  }

  // Content
  Widget searchBar() {
    return Consumer<ExploreViewModel>(
      builder: (context, viewModel, _) => TextField(
        onChanged: (c) => viewModel.setSearchTxt(c),
        style: const TextStyle(fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by place name, city, property type, ...',
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38, width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget gridView() {
    return Consumer<ExploreViewModel>(
      builder: (context, viewModel, child) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.postings.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final posting = viewModel.postings[index];

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: InkWell(
              onTap: () {
                final entity = viewModel.getPostingEntity(posting);
                if (entity != null) {
                  _navigateToViewPostingPage(entity);
                }
              },
              child: PostingGridItem(item: posting),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 15, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [searchBar(), const SizedBox(height: 20), gridView()],
          ),
        ),
      ),
    );
  }
}
