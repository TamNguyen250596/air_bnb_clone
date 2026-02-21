import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'book_posting_viewmodel.dart';

class BookPostingScreen extends StatefulWidget {
  const BookPostingScreen({super.key});

  @override
  State<BookPostingScreen> createState() => _BookPostingScreenState();
}

class _BookPostingScreenState extends State<BookPostingScreen> {

  // Navigation
  void _popBack() {
    final vm = context.read<BookPostingViewModel>();
    context.pop(vm.dates);
  }

  // Content
  PreferredSizeWidget _appBar(BuildContext context) {
    final viewModel = context.read<BookPostingViewModel>();
    return CustomAppBar(title: "Book Posting ${viewModel.name}");
  }

  Widget _timeForm(String tag, String title) {
    return Consumer<BookPostingViewModel>(
      builder: (context, viewModel, child) {
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
                onTap: () {
                  viewModel.setCurrentTag(tag);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: viewModel.currentTag == tag ? Colors.green : Colors.grey[900],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.getInitialDateStr(tag),
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
    return Consumer<BookPostingViewModel>(
      builder: (context, viewModel, _) {
        return CalendarDatePicker(
          initialDate: viewModel.getInitialDate(),
          firstDate: viewModel.firstDate,
          lastDate: viewModel.lastDate,
          onDateChanged: (DateTime pickedDate) {
            viewModel.updateSelectedDate(pickedDate);
          },
          calendarDelegate: const GregorianCalendarDelegate(),
        );
      },
    );
  }

  Widget _bookButton() {
    return Consumer<BookPostingViewModel>(
      builder: (context, viewModel, _) {
        return MaterialButton(
          onPressed: viewModel.canBook ? () { _popBack(); } : null,
          minWidth: double.infinity,
          height: MediaQuery.of(context).size.height / 16,
          color: Colors.green,
          disabledColor: Colors.grey,
          child: const Text('Book Now', style: TextStyle(fontSize: 20)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Spacer(),

            _bookButton()
          ],
        ),
      ),
    );
  }
}
