import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import '../../../models/schedule_model.dart';
import '../../../repositories/schedule_repository.dart';

class ScheduleList extends StatefulWidget {
  final int siteId;

  ScheduleList({required this.siteId});

  @override
  _ScheduleListState createState() => _ScheduleListState();
}

final getIt = GetIt.instance;

class _ScheduleListState extends State<ScheduleList> {
  final PagingController<int, ScheduleModel> _pagingController =
      PagingController(firstPageKey: 0);
  var scheduleRepository = getIt<ScheduleRepository>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newSchedules = await _fetchSchedules(pageKey);

      final isLastPage = newSchedules.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newSchedules);
      } else {
        final nextPageKey = pageKey + newSchedules.length;
        _pagingController.appendPage(newSchedules, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<ScheduleModel>> _fetchSchedules(int pageKey) async {
    return scheduleRepository.fetchSchedules(
      widget.siteId,
      pageNum: pageKey,
    );
  }

  void _openEditDialog(ScheduleModel schedule) async {
    final updatedAnnounce = await showDialog<String>(
      context: context,
      builder: (context) {
        final TextEditingController announceController =
            TextEditingController(text: schedule.announces);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300, // Set a fixed width for the dialog
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Announcement', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 18),
                  TextField(
                    controller: announceController,
                    decoration: InputDecoration(
                      labelText: 'Announcement',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  Text('Name: ${schedule.text}'),
                  Text(
                      'Start Date: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule.startDate)}'),
                  Text(
                      'End Date: ${DateFormat('yyyy-MM-dd HH:mm').format(schedule.endDate)}'),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(announceController.text),
                      child: Text('OK'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (updatedAnnounce != null) {
      schedule.announces = updatedAnnounce;
      await _updateSchedule(schedule);
    }
  }

  Future<void> _updateSchedule(ScheduleModel schedule) async {
    try {
      await scheduleRepository.updateSchedule(widget.siteId, [schedule]);
      _pagingController.refresh();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update announcement')),
      );
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, ScheduleModel>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<ScheduleModel>(
        itemBuilder: (context, schedule, index) {
          final startDate = DateFormat('yyyy-MM-dd HH:mm')
              .format(schedule.startDate); // Format the start date
          final endDate = DateFormat('yyyy-MM-dd HH:mm')
              .format(schedule.endDate); // Format the end date
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
              leading: Icon(Icons.schedule),
              title: Text(schedule.text),
              subtitle: Text('$startDate - $endDate'),
              onTap: () => _openEditDialog(schedule),
            ),
          );
        },
      ),
    );
  }
}
