import 'dart:convert';
import 'package:air_bnb_clone/commons/constants/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _paymentIntentsUrl = 'https://api.stripe.com/v1/payment_intents';

  String get _secretKey =>
      dotenv.env[AppConstants.stripeSecretKey] ?? '';

  /// Creates a Stripe Payment Intent. Amount is in cents (e.g. 1000 = $10.00).
  /// Returns the API response as JSON on success; throws on non-200 or missing key.
  Future<Map<String, dynamic>> createPaymentIntent({
    required String name,
    required String address,
    required String amount,
    String currency = 'USD',
    String description = 'Booking Payment for Property',
    String country = 'USA',
  }) async {
    final key = _secretKey;
    if (key.isEmpty) {
      throw StateError('STRIPE_SECRET_KEY is not set');
    }

    final body = <String, String>{
      'amount': amount,
      'currency': currency,
      'automatic_payment_methods[enabled]': 'true',
      'description': description,
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][country]': country,
    };

    final encodedBody = body.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await http.post(
      Uri.parse(_paymentIntentsUrl),
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: encodedBody,
    );

    if (response.statusCode != 200) {
      throw StripeException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class StripeException implements Exception {
  StripeException({required this.statusCode, this.body});

  final int statusCode;
  final String? body;

  @override
  String toString() => 'StripeException: $statusCode ${body ?? ""}';
}
