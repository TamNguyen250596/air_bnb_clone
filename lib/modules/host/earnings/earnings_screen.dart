import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'earnings_cubit.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  Widget _totalText() {
    return BlocBuilder<EarningsCubit, EarningsState>(
        builder: (context, state) => Text(
          state.totalMoney,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
    );
  }

  Widget _totalErnView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your Earnings",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),

        SizedBox(height: 20),

        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.account_balance_wallet, size: 60, color: Colors.white),
                SizedBox(height: 15),
                _totalText(),
                SizedBox(height: 10),
                Text(
                  "Total Earnings",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Earnings'),
      body: Center(
        child: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) => state.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : _totalErnView(context),
        ),
      ),
    );
  }
}