class Place {

  // Properties
  late final String id;
  String? name;
  String? country;
  String? city;
  String? address;

  // Constructor
  Place(this.id, this.name, this.country);

  Place.fromJson(Map<String, dynamic> map) {
    final properties = map['properties'];

    id = properties['place_id'];
    name = properties['name'];
    country = properties['country'];
    city = properties['city'];
    address = properties['formatted'];
  }
}