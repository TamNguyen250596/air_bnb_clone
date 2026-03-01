import 'package:air_bnb_clone/data/models/stripe/payment_intent.dart';
import 'package:air_bnb_clone/data/services/stripe_service.dart';

/// Abstract contract for creating Stripe Payment Intents.
/// Use [StripePaymentIntentRepositoryImpl] in app and a fake in unit tests.
abstract class StripePaymentIntentRepository {
  Future<PaymentIntent> createPaymentIntent({
    required String name,
    required String address,
    required String amount,
  });
}

class StripePaymentIntentRepositoryImpl implements StripePaymentIntentRepository {
  StripePaymentIntentRepositoryImpl({required StripeService stripeService})
      : _stripeService = stripeService;

  final StripeService _stripeService;

  @override
  Future<PaymentIntent> createPaymentIntent({
    required String name,
    required String address,
    required String amount,
  }) async {
    final json = await _stripeService.createPaymentIntent(
      name: name,
      address: address,
      amount: amount,
    );
    return PaymentIntent.fromJson(json);
  }
}
