import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:guard_client/ui/widgets/marqee.dart';
import 'package:guard_client/ui/widgets/placeholder_image.dart';
import 'package:guard_client/blocs/site/site_bloc.dart';
import 'package:guard_client/blocs/event/event_bloc.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    context.read<SiteBloc>().add(FetchSites());
    context.read<EventBloc>().add(FetchEvents(id: 0));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getCurrentDay() {
    DateTime now = DateTime.now();
    return DateFormat('d').format(now);
  }

  String getCurrentWeekdayAndTime() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE - h:mm a').format(now);
  }

  String getCurrentMonthAndYear() {
    DateTime now = DateTime.now();
    return DateFormat('MMMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the custom height
        child: AppBar(
          title: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                  child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ))),
          surfaceTintColor: Color.fromARGB(255, 245, 247, 250),
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0, // Remove shadow
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Date
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor, // Fill the region with blue color
                  borderRadius:
                      BorderRadius.circular(10.0), // Set the radius here
                  border: Border.all(
                    color: Colors.white, // Border color
                    width: 2, // Border width
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getCurrentDay(),
                      style: TextStyle(
                        fontSize: 80, // Font size for the day
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        width: 16), // Space between day and weekday/month/year
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getCurrentWeekdayAndTime(),
                          style: TextStyle(
                            fontSize: 20, // Font size for weekday and time
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          getCurrentMonthAndYear(),
                          style: TextStyle(
                            fontSize: 20, // Font size for month and year
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Sites Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sites',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<SiteBloc, SiteState>(
                    builder: (context, state) {
                      if (state is SiteLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor));
                      } else if (state is SiteError) {
                        return Center(child: Text('Failed to load sites'));
                      } else if (state is SiteListLoaded) {
                        return Container(
                          height: 150, // Adjust as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.sites.length,
                            itemBuilder: (context, index) {
                              final site = state.sites[index];
                              return Container(
                                width: 100, // Adjust as needed
                                margin: EdgeInsets.only(right: 16),
                                child: Column(
                                  children: [
                                    PlaceholderImage(), // Use the PlaceholderImage widget here
                                    SizedBox(height: 8),
                                    Container(
                                      width:
                                          100, // Set the width to be the same as the image
                                      child: site.name.length > 10
                                          ? Marquee(
                                              text: site.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Center(
                                              child: Text(
                                                site.name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: Text('No sites available'));
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Events Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Events',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<SiteBloc, SiteState>(
                        builder: (context, state) {
                          if (state is SiteLoading) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor));
                          } else if (state is SiteError) {
                            return Center(child: Text('Failed to load events'));
                          } else if (state is SiteListLoaded) {
                            // Fetch events for each site
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.sites.length,
                              itemBuilder: (context, index) {
                                return BlocBuilder<EventBloc, EventState>(
                                  builder: (context, eventState) {
                                    if (eventState is EventListLoaded) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: eventState.events.map(
                                          (event) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    title:
                                                        Text(event.description),
                                                    onTap: () {
                                                      // Navigate to event details if needed
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                );
                              },
                            );
                          } else {
                            return Center(child: Text('No events available'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
