import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../blocs/site/site_bloc.dart';
import '../../../models/report_model.dart';
import '../../../repositories/report_repository.dart';
import '../../../models/report_model.dart';
import '../../../repositories/report_repository.dart';
import './report_detail_screen.dart';
import 'package:get_it/get_it.dart';
import '../../../models/site_model.dart';
import '../../../models/location_model.dart';
import '../../../utils/route_observer.dart';
import 'dart:async';

class ReportScreen extends StatefulWidget {
  final int? siteId; // Allow siteId to be nullable

  ReportScreen({this.siteId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

final getIt = GetIt.instance;

class _ReportScreenState extends State<ReportScreen> with RouteAware {
  int? _selectedSiteId;
  DateTime? startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime? endDate = DateTime.now();
  final PagingController<int, ReportModel> _pagingController =
      PagingController(firstPageKey: 0);
  var reportRepository = getIt<ReportRepository>();

  @override
  void initState() {
    super.initState();
    _selectedSiteId = widget.siteId;
    context.read<SiteBloc>().add(FetchSites());

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newReports = await _fetchReports(pageKey);

      final isLastPage = newReports.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newReports);
      } else {
        final nextPageKey = pageKey + newReports.length;
        _pagingController.appendPage(newReports, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<ReportModel>> _fetchReports(int pageKey) async {
    return reportRepository.fetchReports(_selectedSiteId ?? widget.siteId ?? 0,
        pageNum: pageKey, startDate: startDate, endDate: endDate);
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
      'Report List',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: title(),
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
                return PagedListView<int, ReportModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ReportModel>(
                    itemBuilder: (context, report, index) {
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(report.timestamp); // Format the timestamp
                      String? siteName;
                      if (state is SiteListLoaded) {
                        siteName = state.sites
                            .firstWhere((site) => site.id == report.site.id,
                                orElse: () => SiteModel(
                                    id: 0,
                                    name: 'Unknown Site',
                                    description: '',
                                    location: LocationModel(
                                        latitude: 0.0, longitude: 0.0)))
                            .name;
                      }
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
                          leading: null, // Add the initials icon here if needed
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(report.nature),
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportDetailScreen(report: report),
                              ),
                            );
                          },
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
