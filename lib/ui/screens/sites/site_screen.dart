import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_client/ui/screens/sites/site_detail_screen.dart';
import '../../../blocs/site/site_bloc.dart';
import './site_form_screen.dart';
import '../../widgets/initial_icon.dart';
import '../../../utils/route_observer.dart';
import './site_home_screen.dart';

class SiteScreen extends StatefulWidget {
  @override
  _SiteScreenState createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
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
    context.read<SiteBloc>().add(FetchSites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sites'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<SiteBloc>().add(RefreshSites());
            },
          ),
        ],
      ),
      body: BlocBuilder<SiteBloc, SiteState>(
        builder: (context, state) {
          if (state is SiteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SiteError) {
            return Center(child: Text('Failed to load sites'));
          } else if (state is SiteListLoaded) {
            return ListView.builder(
              itemCount: state.sites.length,
              itemBuilder: (context, index) {
                final site = state.sites[index];
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
                    leading: InitialsIcon(
                        name: site.name), // Add the initials icon here
                    title: Text(site.name),
                    subtitle: Text(site.address!,
                        style: TextStyle(color: Colors.grey)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SiteHomeScreen(
                            site: site,
                          ),
                        ),
                      ).then((_) {
                        // Refresh the list when coming back from the detail screen
                        context.read<SiteBloc>().add(FetchSites());
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No sites available'));
          }
        },
      ),
    );
  }
}
