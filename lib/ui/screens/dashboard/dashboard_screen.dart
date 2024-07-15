import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:guard_client/ui/widgets/marqee.dart';
import 'package:guard_client/ui/widgets/placeholder_image.dart';
import 'package:guard_client/blocs/site/site_bloc.dart';
import 'package:guard_client/blocs/event/event_bloc.dart';
import 'package:guard_client/ui/screens/sites/site_detail_screen.dart';
import 'dart:async';
import '../../../utils/util.dart';
import '../../../models/event_model.dart';
import '../../../models/site_model.dart';
import '../../../models/location_model.dart';

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
    context.read<EventBloc>().add(FetchEvents(id: 352));
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

  String _truncateDescription(String description) {
    const maxLength = 24; // Adjust the max length as needed
    if (description.length > maxLength) {
      return '${description.substring(0, maxLength)}...';
    }
    return description;
  }

  IconData _getIconDataForAction(String action) {
    switch (action.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'flood':
        return Icons.water_damage;
      case 'blackout':
        return Icons.power_off;
      case 'water leak':
        return Icons.water;
      case 'visitor':
        return Icons.person;
      case 'trespasser':
        return Icons.person_off;
      case 'fire alarm':
        return Icons.alarm;
      case 'squatter':
        return Icons.cabin;
      case 'drug paraphernalia':
        return Icons.medical_services;
      case 'vagrant':
        return Icons.person_search;
      case 'police':
        return Icons.local_police;
      case 'door not secure':
        return Icons.lock_open;
      case 'deceased':
        return Icons.sentiment_very_dissatisfied;
      case 'ems':
        return Icons.local_hospital;
      case 'suspicious vehicle':
        return Icons.directions_car;
      case 'dangerous chemical':
        return Icons.warning;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForAction(String action) {
    switch (action.toLowerCase()) {
      case 'fire':
        return Colors.red;
      case 'flood':
        return Colors.blue;
      case 'blackout':
        return Colors.grey;
      case 'water leak':
        return Colors.lightBlue;
      case 'visitor':
        return Colors.green;
      case 'trespasser':
        return Colors.orange;
      case 'fire alarm':
        return Colors.redAccent;
      case 'squatter':
        return Colors.brown;
      case 'drug paraphernalia':
        return Colors.purple;
      case 'vagrant':
        return Colors.amber;
      case 'police':
        return Colors.blueAccent;
      case 'door not secure':
        return Colors.orangeAccent;
      case 'deceased':
        return Colors.black;
      case 'ems':
        return Colors.red;
      case 'suspicious vehicle':
        return Colors.indigo;
      case 'dangerous chemical':
        return Colors.yellow;
      default:
        return Colors.blueGrey;
    }
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
              ),
            ),
          ),
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
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<SiteBloc, SiteState>(
                    builder: (context, state) {
                      if (state is SiteLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SiteDetailScreen(site: site),
                                    ),
                                  );
                                },
                                child: Container(
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
                                                style: TextStyle(fontSize: 14),
                                              )
                                            : Center(
                                                child: Text(
                                                  site.name,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
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
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<EventBloc, EventState>(
                        builder: (context, eventState) {
                          if (eventState is EventLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          } else if (eventState is EventError) {
                            return Center(child: Text('Failed to load events'));
                          } else if (eventState is EventListLoaded) {
                            return Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: eventState.events.length,
                                itemBuilder: (context, index) {
                                  final event = eventState.events[index];
                                  final formattedDate = DateFormat('yyyy-MM-dd')
                                      .format(event.timestamp);
                                  final iconData =
                                      _getIconDataForAction(event.action);
                                  final iconColor =
                                      _getColorForAction(event.action);
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 0.5,
                                          color: Color.fromARGB(
                                              100, 200, 200, 200),
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(iconData,
                                          color:
                                              iconColor), // Add the initials icon here
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(event.description),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle:
                                          BlocBuilder<SiteBloc, SiteState>(
                                        builder: (context, siteState) {
                                          if (siteState is SiteListLoaded) {
                                            final siteName = siteState.sites
                                                .firstWhere(
                                                    (site) =>
                                                        site.id == event.siteId,
                                                    orElse: () => SiteModel(
                                                        id: 0,
                                                        name: 'Unknown Site',
                                                        description: '',
                                                        location: LocationModel(
                                                            latitude: 0.0,
                                                            longitude: 0.0)))
                                                .name;
                                            return Text(siteName,
                                                style: TextStyle(
                                                    color: Colors.grey));
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                      onTap: () {
                                        // Navigate to event details if needed
                                      },
                                    ),
                                  );
                                },
                              ),
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
