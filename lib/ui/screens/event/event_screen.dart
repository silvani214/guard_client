import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import to use SVG icons
import '../../../blocs/event/event_bloc.dart';
import '../../../blocs/site/site_bloc.dart';
import '../../widgets/initial_icon.dart';
import '../../../utils/route_observer.dart';
import '../../../models/event_model.dart';
import '../../../models/site_model.dart';
import '../../../models/location_model.dart';
import 'dart:async';

class EventScreen extends StatefulWidget {
  final int? siteId; // Allow siteId to be nullable
  final bool isDetail;

  EventScreen({this.siteId, this.isDetail = false});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with RouteAware {
  int? _selectedSiteId;
  DateTime? startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime? endDate = DateTime.now();
  String _range = '';
  final PagingController<int, EventModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    context.read<SiteBloc>().add(FetchSites());
    _selectedSiteId = widget.siteId;
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newEvents = await _fetchEvents(pageKey);

      final isLastPage = newEvents.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newEvents);
      } else {
        final nextPageKey = pageKey + newEvents.length;
        _pagingController.appendPage(newEvents, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<EventModel>> _fetchEvents(int pageKey) async {
    final Completer<List<EventModel>> completer = Completer();
    context.read<EventBloc>().add(FetchEvents(
        id: _selectedSiteId ?? widget.siteId ?? 0,
        pageNum: pageKey,
        startDate: startDate,
        endDate: endDate,
        completer: completer));
    return completer.future;
  }

  void _applyFilters() {
    _pagingController.refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _applyFilters();
  }

  Widget title() {
    return Text(
      'Event',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _truncateDescription(String description) {
    const maxLength = 30; // Adjust the max length as needed
    if (description.length > maxLength) {
      return '${description.substring(0, maxLength)}...';
    }
    return description;
  }

  String _formatDateRange(DateTime start, DateTime end) {
    return '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}';
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
        // return Icons.biohazard;
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
          surfaceTintColor: Theme.of(context).primaryColor,
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0, // Remove shadow
          leading: widget.isDetail
              ? IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          title: widget.isDetail ? title() : Center(child: title()),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<SiteBloc, SiteState>(
                    builder: (context, state) {
                      if (state is SiteListLoaded) {
                        if (_selectedSiteId == null && state.sites.isNotEmpty) {
                          _selectedSiteId = state.sites.first.id;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _applyFilters();
                          });
                        }
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            isExpanded: true,
                            hint: Text(
                              'Select Site',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: state.sites
                                .map((site) => DropdownMenuItem<int>(
                                      value: site.id,
                                      child: Text(
                                        site.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: _selectedSiteId,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedSiteId = value;
                              });
                              _applyFilters();
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    showCustomDateRangePicker(
                      context,
                      dismissible: true,
                      minimumDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      maximumDate: DateTime.now().add(const Duration(days: 30)),
                      endDate: endDate,
                      startDate: startDate,
                      backgroundColor: Colors.white,
                      primaryColor: Theme.of(context).primaryColor,
                      onApplyClick: (start, end) {
                        setState(() {
                          endDate = end;
                          startDate = start;
                          _applyFilters();
                        });
                      },
                      onCancelClick: () {
                        setState(() {
                          endDate = null;
                          startDate = null;
                        });
                      },
                    );
                  },
                  child: Text(
                    startDate != null && endDate != null
                        ? _formatDateRange(startDate!, endDate!)
                        : 'Select Date Range',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SiteBloc, SiteState>(
              builder: (context, state) {
                return PagedListView<int, EventModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<EventModel>(
                    itemBuilder: (context, event, index) {
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(event.timestamp); // Format the timestamp
                      String? siteName;
                      if (state is SiteListLoaded) {
                        siteName = state.sites
                            .firstWhere((site) => site.id == event.siteId,
                                orElse: () => SiteModel(
                                    id: 0,
                                    name: 'Unknown Site',
                                    description: '',
                                    location: LocationModel(
                                        latitude: 0.0, longitude: 0.0)))
                            .name;
                      }
                      final iconData = _getIconDataForAction(event.action);
                      final iconColor = _getColorForAction(event.action);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromARGB(100, 200, 200, 200),
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(iconData,
                              color: iconColor), // Add the initials icon here
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          subtitle: siteName != null
                              ? Text(siteName,
                                  style: TextStyle(color: Colors.grey))
                              : null,
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
