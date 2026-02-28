import 'package:flutter/cupertino.dart';

class BaseItemModel {

  // Properties
  late final String id;
  String tag;
  IconData? imageData;
  String imageUrl;
  String title;
  String des;
  dynamic object;

  // Constructor
  BaseItemModel(this.id,
      {this.tag = "", this.imageData, this.imageUrl = "", this.title = "", this.des = "", this.object});
}