import 'base_item_model.dart';

class TripGridItemModel extends BaseItemModel {

  // Constructor
  TripGridItemModel(
      super.id, {
        this.price = "",
        this.bookedDatesDes = "",
        super.tag,
        super.imageData,
        super.imageUrl,
        super.title,
        super.des,
        super.object,
      });

  // Properties
  String price;
  String bookedDatesDes;
}