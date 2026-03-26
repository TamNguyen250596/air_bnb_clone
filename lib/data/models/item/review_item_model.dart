import 'base_item_model.dart';

class ReviewItemModel extends BaseItemModel {
  ReviewItemModel(
    super.id, {
    this.rating = 0.0,
    super.tag,
    super.imageData,
    super.imageUrl,
    super.title,
    super.des,
    super.object,
  });

  double rating;
}
