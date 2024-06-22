import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sitemap/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../blocs/site/site_bloc.dart';
import '../../../models/site_model.dart';
import '../../../models/location_model.dart';
import '../../widgets/form_text_field.dart';
import 'map_screen.dart';

class SiteFormScreen extends StatelessWidget {
  final bool isEditMode;
  final SiteModel? site;

  SiteFormScreen({required this.isEditMode, this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Site' : 'Create Site'),
        actions: this.isEditMode
            ? [
                IconButton(
                  icon: Icon(Icons.report),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {},
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SiteForm(
          isEditMode: isEditMode,
          site: site,
        ),
      ),
    );
  }
}

class SiteForm extends StatefulWidget {
  final bool isEditMode;
  final SiteModel? site;

  SiteForm({required this.isEditMode, this.site});

  @override
  _SiteFormState createState() => _SiteFormState();
}

class _SiteFormState extends State<SiteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String? _address;
  String _location = 'Select Location';
  LocationModel? _selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.site != null) {
      _name = widget.site!.name;
      _description = widget.site!.description!;
      _address = widget.site!.address;
      _location = widget.isEditMode
          ? (_address ??
              '${widget.site!.location.latitude}\n${widget.site!.location.longitude}')
          : '${widget.site!.location.latitude}\n${widget.site!.location.longitude}';
      _selectedLocation = widget.site!.location;
    } else {
      _name = '';
      _description = '';
    }
  }

  void _selectLocation() async {
    final LatLng selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = LocationModel(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
        );
        _location = widget.isEditMode
            ? (_address ??
                '${selectedLocation.latitude}\n${selectedLocation.longitude}')
            : '${selectedLocation.latitude}\n${selectedLocation.longitude}';
      });
    }
  }

  void _submitForm() {
    if (widget.isEditMode) {
      Navigator.of(context).pop();
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.isEditMode) {
        BlocProvider.of<SiteBloc>(context).add(UpdateSite(
          site: widget.site!.copyWith(
            name: _name,
            description: _description,
            location: _selectedLocation ?? widget.site!.location,
          ),
        ));
      } else {
        BlocProvider.of<SiteBloc>(context).add(CreateSite(
            site: widget.site!.copyWith(
          name: _name,
          description: _description,
          location: _selectedLocation ?? widget.site!.location,
        )));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormTextField(
            initialValue: _name,
            labelText: 'Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) => _name = value!,
          ),
          SizedBox(height: 16),
          FormTextField(
            initialValue: _description,
            maxLines: 5, // This makes it a textarea
            labelText: 'Description',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onSaved: (value) => _description = value!,
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectLocation,
              child: Text(_location),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.isEditMode ? 'Back' : 'Create Site'),
            ),
          ),
        ],
      ),
    );
  }
}
