import 'package:air_bnb_clone/modules/guest/explore/explore_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  void _navigateToViewPostingPage(Posting posting) {
    context.pushNamed(RouteConstant.viewPosting, extra: posting);
  }

  Widget searchBar() {
    return BlocBuilder<ExploreCubit, ExploreState>(
      buildWhen: (_, __) => false,
      builder: (context, state) {
        return TextField(
          onChanged: (c) => context.read<ExploreCubit>().setSearchTxt(c),
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
      );
      },
    );
  }

  Widget gridView() {
    return BlocBuilder<ExploreCubit, ExploreState>(
      builder: (context, state) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.postings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final posting = state.postings[index];
            final cubit = context.read<ExploreCubit>();
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  final entity = cubit.getPostingEntity(posting);
                  if (entity != null) {
                    _navigateToViewPostingPage(entity);
                  }
                },
                child: PostingGridItem(item: posting),
              ),
            );
          },
        );
      },
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
