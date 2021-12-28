import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:flutter_complete_guide/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      final String id = ModalRoute.of(context)!.settings.arguments.toString();

      final selectedPlace =
          Provider.of<GreatPlaces>(context, listen: false).findById(id);

      return Scaffold(
          appBar: AppBar(
            title: Text(selectedPlace.title),
          ),
          body: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                child: Image.file(
                  selectedPlace.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (selectedPlace.location != null &&
                  selectedPlace.location!.address != null)
                Text(
                  selectedPlace.location!.address!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              SizedBox(height: 10),
              TextButton(
                  child: Text('View on map'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    if (selectedPlace.location != null)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (ctx) => MapScreen(
                            initialLocation: selectedPlace.location!,
                            isSelected: false,
                          ),
                        ),
                      );
                  }),
            ],
          ));
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
