import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/report_model.dart';
import '../../../repositories/report_repository.dart';
import 'package:get_it/get_it.dart';
import 'report_detail_screen.dart'; // Import the detail screen

class ReportScreen extends StatefulWidget {
  final int siteId;

  ReportScreen({required this.siteId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

final getIt = GetIt.instance;

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<ReportModel>> _reportFuture;
  var reportRepository = getIt<ReportRepository>();

  @override
  void initState() {
    super.initState();
    _reportFuture = reportRepository.fetchReports(widget.siteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(
            'Report List',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          surfaceTintColor: Color.fromARGB(255, 245, 247, 250),
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: FutureBuilder<List<ReportModel>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Failed to load reports'));
          } else if (snapshot.hasData) {
            final reports = snapshot.data!;
            return Scrollbar(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
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
                      leading: Icon(Icons.report),
                      title: Text(report.nature),
                      subtitle: Text(report.description),
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
          } else {
            return Center(child: Text('No reports available'));
          }
        },
      ),
    );
  }
}
