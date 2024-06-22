import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/event/event_bloc.dart';
import '../../widgets/initial_icon.dart';
import '../../../utils/route_observer.dart';

class EventScreen extends StatefulWidget {
  final int siteId;

  EventScreen({required this.siteId});
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(FetchEvents(id: widget.siteId));
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
    context.read<EventBloc>().add(FetchEvents(id: widget.siteId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<EventBloc>().add(RefreshEvents(id: widget.siteId));
            },
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventError) {
            return Center(child: Text('Failed to load events'));
          } else if (state is EventListLoaded) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
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
                    title: Text(event.title),
                    subtitle: Text(event.description,
                        style: TextStyle(color: Colors.grey)),
                    onTap: () {},
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No events available'));
          }
        },
      ),
    );
  }
}
