import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/location_helpers.dart';
import 'package:flutter_complete_guide/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    try {
      final loc = await Location().getLocation();
      if (loc.latitude != null && loc.longitude != null)
        _showPreview(loc.latitude!, loc.longitude!);
      widget.onSelectPlace(loc.latitude, loc.longitude);
    } catch (error) {
      return;
    }
  }

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationsHelpers.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelected: true,
        ),
      ),
    );

    if (selectedLocation == null) return;
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Center(
                  child: Text(
                    'No location chosen',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: Icon(Icons.location_on),
                label: Text(
                  'Current location',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
            TextButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text(
                  'Select on map',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
          ],
        )
      ],
    );
  }
}
