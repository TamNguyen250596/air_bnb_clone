import 'package:air_bnb_clone/commons/widgets/image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'bookings_cubit.dart';

// ========== Bookings Screen Widget ==========
class BookingsPage extends StatelessWidget {
  // ========== Constructor ==========
  const BookingsPage({super.key});

  // Content
  Widget _postingList(BuildContext context) {
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          child: ListView.builder(
            itemCount: state.postings.length,
            itemBuilder: (context, index) {
              final item = state.postings[index];
              final bool isSelected = context
                  .read<BookingsCubit>()
                  .isPostingSelected(item);

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: InkWell(
                  onTap: () {
                    context.read<BookingsCubit>().selectPosting(item);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade600,
                        width: isSelected ? 4.0 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ImageItem(item: item),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _calendar(BuildContext context) {
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        return CalendarDatePicker(
          initialDate: null,
          firstDate: state.firstDate,
          lastDate: state.lastDate,
          onDateChanged: (DateTime pickedDate) {},
          calendarDelegate: const GregorianCalendarDelegate(),
          selectableDayPredicate: (date) => state.isDaySelectable(date),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Bookings'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Filter by Posting',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
            ),
            _postingList(context),
            _calendar(context),
          ],
        ),
      ),
    );
  }
}
