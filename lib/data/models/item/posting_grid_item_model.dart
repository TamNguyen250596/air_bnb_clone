import 'package:air_bnb_clone/data/models/item/base_item_model.dart';

class PostingGridItemModel extends BaseItemModel {

  // Constructor
  PostingGridItemModel(
    super.id, {
    this.price = "",
    this.rating = 0.0,
    this.ratingStr = "",
    super.tag,
    super.imageData,
    super.imageUrl,
    super.title,
    super.des,
    super.object,
  });

  // Properties
  String price;
  double rating;
  String ratingStr;
}