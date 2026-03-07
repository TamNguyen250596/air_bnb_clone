import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/item/trip_grid_item_model.dart';

class TripGridItem extends StatelessWidget {
  const TripGridItem({super.key, required this.item});

  final TripGridItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: (item.imageUrl.isEmpty)
              ? Container()
              : CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  placeholder: (context, url) => SizedBox(
                    height: 5.0,
                    width: 5.0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  fit: BoxFit.contain,
                ),
        ),

        Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(item.des, maxLines: 1, style: const TextStyle(fontSize: 14)),
              Text(
                item.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.bookedDatesDes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
