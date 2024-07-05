import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import '../../../blocs/event/event_bloc.dart';
import '../../../blocs/site/site_bloc.dart';
import '../../widgets/initial_icon.dart';
import '../../../utils/route_observer.dart';

class EventScreen extends StatefulWidget {
  final int? siteId; // Allow siteId to be nullable
  final bool isDetail;

  EventScreen({this.siteId, this.isDetail = false});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with RouteAware {
  int? _selectedSiteId;
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  String _range = '';

  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(
        FetchEvents(id: widget.siteId ?? 0)); // Default to 0 if siteId is null
    context.read<SiteBloc>().add(FetchSites());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<EventBloc>().add(
        FetchEvents(id: widget.siteId ?? 0)); // Default to 0 if siteId is null
  }

  void _applyFilters() {
    context.read<EventBloc>().add(FetchEvents(
          id: _selectedSiteId ??
              widget.siteId ??
              0, // Default to 0 if siteId is null
          // dateRange: DateTimeRange(start: startDate!, end: endDate!),
        ));
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
                        return CircularProgressIndicator();
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
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventError) {
                  return Center(child: Text('Failed to load events'));
                } else if (state is EventListLoaded) {
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        final formattedDate = DateFormat('yyyy-MM-dd')
                            .format(event.timestamp); // Format the timestamp
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
                            leading: null, // Add the initials icon here
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      _truncateDescription(event.description)),
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
                            subtitle: Text(event.description,
                                style: TextStyle(color: Colors.grey)),
                            onTap: () {},
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
    );
  }
}
