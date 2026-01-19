import 'package:air_bnb_clone/commons/widgets/custom_app_bar.dart';
import 'package:air_bnb_clone/commons/widgets/place_item.dart';
import 'package:air_bnb_clone/modules/host/search_property_location/search_property_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/place/place.dart';

class SearchPropertyLocationScreen extends StatefulWidget {

  // Init
  const SearchPropertyLocationScreen({super.key, required this.viewModel});

  // Properties
  final SearchPropertyLocationViewModel viewModel;

  @override
  State<SearchPropertyLocationScreen> createState() => _SearchPropertyLocationScreenState();
}

class _SearchPropertyLocationScreenState extends State<SearchPropertyLocationScreen> {

  // Properties
  final TextEditingController _search = TextEditingController();

  // Navigate
  void popBack(Place place) {
    context.pop(place);
  }

  // Build
  Widget _searchField() {
    return Row(
      children: [
        Image.asset(
          "assets/images/final.png",
          height: 16,
          width: 16,
          color: Colors.white70,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: TextField(
                controller: _search,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                onChanged: (inputText) {
                  widget.viewModel.setSearchTxt(inputText);
                },
                decoration: const InputDecoration(
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 11, top: 9, bottom: 9),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _list() {
    if (widget.viewModel.places.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[850],
              elevation: 3,
              child: PlaceItem(
                place: widget.viewModel.places[index],
                onPress: () {
                  popBack(widget.viewModel.places[index]);
                },
              ),
            );
          },
          separatorBuilder: (context, index) =>
          const SizedBox(height: 2),
          itemCount: widget.viewModel.places.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: CustomAppBar(title: "Please write address"),
          body: Column(
            children: [
              Card(
                color: Colors.black,
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  child: Column(
                    children: [
                      _searchField()
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _list(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
