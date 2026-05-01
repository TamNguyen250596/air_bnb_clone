import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';
import '../booking/booking.dart';
import '../favourite_posting/favourite_posting.dart';
import '../user/user.dart';

extension PostingFirestoreExtension on Posting {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (price != null) 'price': price,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (rating != null) 'rating': rating,
      if (hostId != null) 'host_id': hostId,
      if (images.isNotEmpty) 'images': images,
      if (amenities.isNotEmpty) 'amenities': amenities,
      if (beds.isNotEmpty) 'beds': beds,
      if (bathrooms.isNotEmpty) 'bathrooms': bathrooms,
      "lat": lat,
      "lon": lon,
    };
  }
}

extension PostingRelationshipExtension on Posting {
  static List<RealmRelationship> get realmOutgoingRelationships => [
        RealmRelationship<User>('host_id', 'host'),
      ];

  static List<RealmRelationship> get realmIncomingRelationships => [
        RealmRelationship<Booking>('posting_id', 'posting'),
        RealmRelationship<FavouritePosting>('posting_id', 'posting'),
      ];
}

class PostingFirestoreHelper {
  static Posting fromFirestore(Map<String, dynamic> data) {
    return Posting(
      data['id'] ?? "",
      name: data['name'],
      type: data['type'],
      price: (data['price'] as num?)?.toDouble(),
      description: data['description'],
      address: data['address'],
      city: data['city'],
      country: data['country'],
      rating: (data['rating'] as num?)?.toDouble(),
      hostId: data['host_id'],
      host: data['host'] as User?,
      images: List<String>.from(data['images'] ?? []),
      amenities: List<String>.from(data['amenities'] ?? []),
      beds: Map<String, int>.from(data['beds'] ?? {}),
      bathrooms: Map<String, int>.from(data['bathrooms'] ?? {}),
      lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (data['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
