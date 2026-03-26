import 'package:air_bnb_clone/modules/guest/saved/saved_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/bordered_container.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/posting_grid_item.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../routing/route_id.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  void _navigateToViewPostingPage(BuildContext context, Posting posting) {
    context.pushNamed(RouteConstant.viewPosting, extra: posting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorites'),
      body: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: GridView.builder(
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.postings.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final item = state.postings[index];
                    final cubit = context.read<SavedCubit>();

                    return BorderedContainer(
                      child: InkWell(
                        onTap: () {
                          final entity = cubit.getPostingEntity(item);
                          if (entity != null) {
                            _navigateToViewPostingPage(context, entity);
                          }
                        },
                        child: PostingGridItem(
                          item: item,
                          onClearPressed: () async {
                            await cubit.deleteSavedFavourite(item);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.isLoading)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.08),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
