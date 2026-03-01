/// Stripe Payment Intent API response.
/// See: https://api.stripe.com/v1/payment_intents
class PaymentIntent {
  PaymentIntent({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCapturable,
    required this.amountReceived,
    required this.clientSecret,
    required this.confirmationMethod,
    required this.created,
    required this.currency,
    required this.description,
    required this.livemode,
    required this.status,
    this.amountDetails,
    this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.customer,
    this.excludedPaymentMethodTypes,
    this.lastPaymentError,
    this.latestCharge,
    this.metadata,
    this.nextAction,
    this.paymentMethod,
    this.paymentMethodConfigurationDetails,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.receiptEmail,
    this.setupFutureUsage,
    this.shipping,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
  });

  final String id;
  final String object;
  final int amount;
  final int amountCapturable;
  final int amountReceived;
  final String clientSecret;
  final String confirmationMethod;
  final int created;
  final String currency;
  final String? description;
  final bool livemode;
  final String status;

  final Map<String, dynamic>? amountDetails;
  final AutomaticPaymentMethods? automaticPaymentMethods;
  final int? canceledAt;
  final String? cancellationReason;
  final String? captureMethod;
  final String? customer;
  final List<String>? excludedPaymentMethodTypes;
  final dynamic lastPaymentError;
  final String? latestCharge;
  final Map<String, dynamic>? metadata;
  final dynamic nextAction;
  final String? paymentMethod;
  final PaymentMethodConfigurationDetails? paymentMethodConfigurationDetails;
  final Map<String, dynamic>? paymentMethodOptions;
  final List<String>? paymentMethodTypes;
  final String? receiptEmail;
  final String? setupFutureUsage;
  final Shipping? shipping;
  final String? statementDescriptor;
  final String? statementDescriptorSuffix;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) {
    return PaymentIntent(
      id: json['id'] as String,
      object: json['object'] as String,
      amount: json['amount'] as int,
      amountCapturable: json['amount_capturable'] as int? ?? 0,
      amountReceived: json['amount_received'] as int? ?? 0,
      clientSecret: json['client_secret'] as String,
      confirmationMethod: json['confirmation_method'] as String? ?? 'automatic',
      created: json['created'] as int,
      currency: json['currency'] as String,
      description: json['description'] as String?,
      livemode: json['livemode'] as bool? ?? false,
      status: json['status'] as String,
      amountDetails: json['amount_details'] as Map<String, dynamic>?,
      automaticPaymentMethods: json['automatic_payment_methods'] != null
          ? AutomaticPaymentMethods.fromJson(
              json['automatic_payment_methods'] as Map<String, dynamic>,
            )
          : null,
      canceledAt: json['canceled_at'] as int?,
      cancellationReason: json['cancellation_reason'] as String?,
      captureMethod: json['capture_method'] as String?,
      customer: json['customer'] as String?,
      excludedPaymentMethodTypes:
          (json['excluded_payment_method_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      lastPaymentError: json['last_payment_error'],
      latestCharge: json['latest_charge'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      nextAction: json['next_action'],
      paymentMethod: json['payment_method'] as String?,
      paymentMethodConfigurationDetails:
          json['payment_method_configuration_details'] != null
              ? PaymentMethodConfigurationDetails.fromJson(
                  json['payment_method_configuration_details']
                      as Map<String, dynamic>,
                )
              : null,
      paymentMethodOptions:
          json['payment_method_options'] as Map<String, dynamic>?,
      paymentMethodTypes:
          (json['payment_method_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      receiptEmail: json['receipt_email'] as String?,
      setupFutureUsage: json['setup_future_usage'] as String?,
      shipping: json['shipping'] != null
          ? Shipping.fromJson(json['shipping'] as Map<String, dynamic>)
          : null,
      statementDescriptor: json['statement_descriptor'] as String?,
      statementDescriptorSuffix:
          json['statement_descriptor_suffix'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'amount': amount,
      'amount_capturable': amountCapturable,
      'amount_received': amountReceived,
      'client_secret': clientSecret,
      'confirmation_method': confirmationMethod,
      'created': created,
      'currency': currency,
      'description': description,
      'livemode': livemode,
      'status': status,
      if (amountDetails != null) 'amount_details': amountDetails,
      if (automaticPaymentMethods != null)
        'automatic_payment_methods': automaticPaymentMethods!.toJson(),
      if (canceledAt != null) 'canceled_at': canceledAt,
      if (cancellationReason != null) 'cancellation_reason': cancellationReason,
      if (captureMethod != null) 'capture_method': captureMethod,
      if (customer != null) 'customer': customer,
      if (excludedPaymentMethodTypes != null)
        'excluded_payment_method_types': excludedPaymentMethodTypes,
      if (lastPaymentError != null) 'last_payment_error': lastPaymentError,
      if (latestCharge != null) 'latest_charge': latestCharge,
      if (metadata != null) 'metadata': metadata,
      if (nextAction != null) 'next_action': nextAction,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentMethodConfigurationDetails != null)
        'payment_method_configuration_details':
            paymentMethodConfigurationDetails!.toJson(),
      if (paymentMethodOptions != null)
        'payment_method_options': paymentMethodOptions,
      if (paymentMethodTypes != null) 'payment_method_types': paymentMethodTypes,
      if (receiptEmail != null) 'receipt_email': receiptEmail,
      if (setupFutureUsage != null) 'setup_future_usage': setupFutureUsage,
      if (shipping != null) 'shipping': shipping!.toJson(),
      if (statementDescriptor != null)
        'statement_descriptor': statementDescriptor,
      if (statementDescriptorSuffix != null)
        'statement_descriptor_suffix': statementDescriptorSuffix,
    };
  }
}

class AutomaticPaymentMethods {
  AutomaticPaymentMethods({
    this.allowRedirects,
    required this.enabled,
  });

  final String? allowRedirects;
  final bool enabled;

  factory AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) {
    return AutomaticPaymentMethods(
      allowRedirects: json['allow_redirects'] as String?,
      enabled: json['enabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        if (allowRedirects != null) 'allow_redirects': allowRedirects,
        'enabled': enabled,
      };
}

class PaymentMethodConfigurationDetails {
  PaymentMethodConfigurationDetails({
    required this.id,
    this.parent,
  });

  final String id;
  final String? parent;

  factory PaymentMethodConfigurationDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentMethodConfigurationDetails(
      id: json['id'] as String,
      parent: json['parent'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (parent != null) 'parent': parent,
      };
}

class Shipping {
  Shipping({
    this.address,
    this.carrier,
    this.name,
    this.phone,
    this.trackingNumber,
  });

  final ShippingAddress? address;
  final String? carrier;
  final String? name;
  final String? phone;
  final String? trackingNumber;

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      address: json['address'] != null
          ? ShippingAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      carrier: json['carrier'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      trackingNumber: json['tracking_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (address != null) 'address': address!.toJson(),
        if (carrier != null) 'carrier': carrier,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (trackingNumber != null) 'tracking_number': trackingNumber,
      };
}

class ShippingAddress {
  ShippingAddress({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  final String? city;
  final String? country;
  final String? line1;
  final String? line2;
  final String? postalCode;
  final String? state;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      city: json['city'] as String?,
      country: json['country'] as String?,
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      postalCode: json['postal_code'] as String?,
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (city != null) 'city': city,
        if (country != null) 'country': country,
        if (line1 != null) 'line1': line1,
        if (line2 != null) 'line2': line2,
        if (postalCode != null) 'postal_code': postalCode,
        if (state != null) 'state': state,
      };
}
