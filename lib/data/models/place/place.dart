class Place {

  // Properties
  late final String id;
  String? name;
  String? country;
  String? city;
  String? address;
  double? lat;
  double? lon;

  // Constructor
  Place(this.id, this.name, this.country);

  Place.fromJson(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;

    id = properties['place_id'];

    final otherNames =
    properties['other_names'] as Map<String, dynamic>?;

    name = _firstNonEmptyString([
      properties['name'],
      otherNames?['name'],
      otherNames?['alt_name'],
    ]);

    country = properties['country'];
    city = properties['city'];
    address = properties['formatted'];
    lat = properties['lat'];
    lon = properties['lon'];
  }

  String _firstNonEmptyString(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return 'NA';
  }
}