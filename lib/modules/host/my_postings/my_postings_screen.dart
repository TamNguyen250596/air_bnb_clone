import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/image_item.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../routing/route_id.dart';
import 'my_postings_cubit.dart';

class MyPostingsPage extends StatefulWidget {
  const MyPostingsPage({super.key});

  @override
  State<MyPostingsPage> createState() => _MyPostingsPageState();
}

class _MyPostingsPageState extends State<MyPostingsPage> {
  void _goToUpdatePostingScreen(Posting? posting) {
    context.pushNamed(RouteConstant.updatePosting, extra: posting);
  }

  Widget _postingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
      child: InkResponse(
        onTap: () => _goToUpdatePostingScreen(null),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 12,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text("Create a Listing", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(BaseItemModel item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
      child: InkResponse(
        onTap: () => _goToUpdatePostingScreen(item.object as Posting),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ImageItem(item: item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPostingsCubit, MyPostingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'My Postings'),
          body: Padding(
            padding: const EdgeInsets.only(top: 23),
            child: ListView.builder(
              itemCount: state.postings.length,
              itemBuilder: (context, index) {
                final item = state.postings[index];
                if (item.id == "create_a_listing") {
                  return _postingButton(context);
                } else {
                  return _item(item);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
