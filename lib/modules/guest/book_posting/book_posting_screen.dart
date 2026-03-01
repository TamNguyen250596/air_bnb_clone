import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import '../../../data/models/stripe/payment_intent.dart';
import 'book_posting_cubit.dart';

class BookPostingScreen extends StatefulWidget {
  const BookPostingScreen({super.key});

  @override
  State<BookPostingScreen> createState() => _BookPostingScreenState();
}

class _BookPostingScreenState extends State<BookPostingScreen> {

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

  void _popBack() {
    final state = context.read<BookPostingCubit>().state;
    context.pop(state.dates);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final state = context.read<BookPostingCubit>().state;
    return CustomAppBar(title: "Book Posting ${state.name}");
  }

  Widget _timeForm(String tag, String title) {
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

  Widget _calendar() {
    return BlocBuilder<BookPostingCubit, BookPostingState>(
      builder: (context, state) {
        final cubit = context.read<BookPostingCubit>();
        return CalendarDatePicker(
          initialDate: state.getInitialDate(),
          firstDate: state.firstDate,
          lastDate: state.lastDate,
          onDateChanged: (DateTime pickedDate) {
            cubit.updateSelectedDate(pickedDate);
          },
          calendarDelegate: const GregorianCalendarDelegate(),
        );
      },
    );
  }

  Widget _bookButton() {
    return BlocBuilder<BookPostingCubit, BookPostingState>(
      builder: (context, state) {
        return MaterialButton(
          onPressed: state.canBook ? context.read<BookPostingCubit>().book : null,
          minWidth: double.infinity,
          height: MediaQuery.of(context).size.height / 16,
          color: Colors.green,
          disabledColor: Colors.grey,
          child: const Text('Book Now', style: TextStyle(fontSize: 20))
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
            TextSnackBar.show(context, state.errorMessage!);
          }
          if (state.paymentIntent != null) {
            await _presentStripePaymentSheet(state.paymentIntent!);
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
                    _timeForm('check_in', 'Check-in'),
                    _timeForm('check_out', 'Check-out'),
                  ],
                ),
                _calendar(),
                const Spacer(),
                _bookButton(),
              ],
            ),
          ),
        )
    );
  }
}
