import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/site/site_bloc.dart';
import './site_form_screen.dart';

class SiteScreen extends StatefulWidget {
  @override
  _SiteScreenState createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the FetchSites event when the screen loads
    context.read<SiteBloc>().add(FetchSites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sites'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SiteFormScreen(isEditMode: false),
                ),
              );
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
          } else if (state is SiteLoaded) {
            return ListView.builder(
              itemCount: state.sites.length,
              itemBuilder: (context, index) {
                final site = state.sites[index];
                return ListTile(
                  title: Text(site.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteFormScreen(
                          isEditMode: true,
                          site: site,
                        ),
                      ),
                    );
                  },
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
