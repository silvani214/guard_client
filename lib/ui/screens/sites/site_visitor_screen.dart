import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/visitor_model.dart';
import '../../../repositories/visitor_repository.dart';
import 'package:get_it/get_it.dart';

class VisitorScreen extends StatefulWidget {
  final int siteId;

  VisitorScreen({required this.siteId});

  @override
  _VisitorScreenState createState() => _VisitorScreenState();
}

final getIt = GetIt.instance;

class _VisitorScreenState extends State<VisitorScreen> {
  late Future<List<VisitorModel>> _visitorFuture;
  var visitorRepository = getIt<VisitorRepository>();

  @override
  void initState() {
    super.initState();
    _visitorFuture = visitorRepository.fetchVisitors(widget.siteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the custom height
        child: AppBar(
          title: Text(
            'Visitor List',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          surfaceTintColor: Color.fromARGB(255, 245, 247, 250),
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0, // Remove shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: FutureBuilder<List<VisitorModel>>(
        future: _visitorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Failed to load reports'));
          } else if (snapshot.hasData) {
            final visitors = snapshot.data!;
            return Scrollbar(
              child: ListView.builder(
                itemCount: visitors.length,
                itemBuilder: (context, index) {
                  final visitor = visitors[index];
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
                      leading: Icon(Icons.person),
                      title: Text(visitor.fullname),
                      subtitle: Text(visitor.company ?? ''),
                      onTap: () {},
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
