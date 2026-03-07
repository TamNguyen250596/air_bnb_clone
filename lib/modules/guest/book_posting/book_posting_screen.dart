import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import '../../../data/models/stripe/payment_intent.dart';
import 'book_posting_cubit.dart';

class BookPostingScreen extends StatelessWidget {
  const BookPostingScreen({super.key});

  Future<void> _presentStripePaymentSheet(PaymentIntent paymentIntent) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: false,
        merchantDisplayName: 'AirBnB Clone',
        paymentIntentClientSecret: paymentIntent.clientSecret,
        customerId: paymentIntent.id,
        style: ThemeMode.dark,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final state = context.read<BookPostingCubit>().state;
    return CustomAppBar(title: "Book Posting ${state.name}");
  }

  Widget _timeForm(BuildContext context, String tag, String title) {
    return BlocBuilder<BookPostingCubit, BookPostingState>(
      builder: (context, state) {
        final cubit = context.read<BookPostingCubit>();
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              GestureDetector(
                onTap: () => cubit.setCurrentTag(tag),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: state.currentTag == tag ? Colors.green : Colors.grey[900],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.getInitialDateStr(tag),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _calendar(BuildContext context) {
    return BlocBuilder<BookPostingCubit, BookPostingState>(
      builder: (context, state) {
        final cubit = context.read<BookPostingCubit>();
        return CalendarDatePicker(
          initialDate: null,
          firstDate: state.firstDate,
          lastDate: state.lastDate,
          onDateChanged: (DateTime pickedDate) {
            cubit.updateSelectedDate(pickedDate);
          },
          calendarDelegate: const GregorianCalendarDelegate(),
          selectableDayPredicate: (date) => state.isDaySelectable(date),
        );
      },
    );
  }

  Widget _bookButton(BuildContext context) {
    return BlocBuilder<BookPostingCubit, BookPostingState>(
      builder: (context, state) {
        final isSaving = state.isSaving;
        final canPress = state.canBook && !isSaving;
        return MaterialButton(
          onPressed: canPress ? context.read<BookPostingCubit>().getPaymentIntent : null,
          minWidth: double.infinity,
          height: MediaQuery.of(context).size.height / 16,
          color: Colors.green,
          disabledColor: Colors.grey,
          child: isSaving
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Book Now', style: TextStyle(fontSize: 20)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookPostingCubit, BookPostingState>(
      listenWhen: (prev, curr) => curr.errorMessage != null || curr.paymentIntent != null,
      listener: (context, state) async {
        if (state.errorMessage != null) {
          if (!context.mounted) return;
          TextSnackBar.show(context, state.errorMessage!);
        }
        if (state.paymentIntent != null) {
          final cubit = context.read<BookPostingCubit>();
          final navigator = Navigator.of(context);
          try {
            await _presentStripePaymentSheet(state.paymentIntent!);
            await cubit.saveBooking();
            if (!context.mounted) return;
            navigator.pop(cubit.state.dates);
          } catch (_) {}
        }
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            spacing: 20,
            children: [
              Row(
                spacing: 10,
                children: [
                  _timeForm(context, 'check_in', 'Check-in'),
                  _timeForm(context, 'check_out', 'Check-out'),
                ],
              ),
              _calendar(context),
              const Spacer(),
              _bookButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
