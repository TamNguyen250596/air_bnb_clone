import 'package:air_bnb_clone/commons/widgets/bordered_container.dart';
import 'package:air_bnb_clone/commons/widgets/trip_grid_item.dart';
import 'package:air_bnb_clone/modules/guest/trips/trips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../routing/route_id.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  void _navigateToViewPostingPage(BuildContext context, Posting posting) {
    context.pushNamed(RouteConstant.viewPosting, extra: posting);
  }

  Widget _upcomingGrid(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: state.upcomingTrips.isEmpty
              ? BorderedContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: const Center(
                      child: Text(
                        'No upcoming trips',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: state.upcomingTrips.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final trip = state.upcomingTrips[index];
                      final cubit = context.read<TripsCubit>();

                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: BorderedContainer(
                            child: InkResponse(
                              enableFeedback: true,
                              child: TripGridItem(item: trip),
                              onTap: () {
                                final entity = cubit.getPostingEntity(trip);
                                if (entity != null) {
                                  _navigateToViewPostingPage(context, entity);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _previousGrid(BuildContext context) {
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: state.previousTrips.isEmpty
              ? BorderedContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: const Center(
                      child: Text(
                        'No previous trips',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: state.previousTrips.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final trip = state.previousTrips[index];
                      final cubit = context.read<TripsCubit>();

                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: BorderedContainer(
                            child: InkResponse(
                              enableFeedback: true,
                              child: TripGridItem(item: trip),
                              onTap: () {
                                final entity = cubit.getPostingEntity(trip);
                                if (entity != null) {
                                  _navigateToViewPostingPage(context, entity);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Trips'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  'Upcoming Trips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              _upcomingGrid(context),
              const Text(
                'Previous Trips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              _previousGrid(context),
            ],
          ),
        ),
      ),
    );
  }
}
