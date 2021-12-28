import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/db_helpers.dart';
import 'package:flutter_complete_guide/helpers/location_helpers.dart';
import 'package:flutter_complete_guide/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationsHelpers.getPlaceAdress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedPlace = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updatedPlace,
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    if (newPlace.location != null && newPlace.location!.address != null) {
      DBHelper.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address!,
      });
    }
  }

  void deleteTable() {
    DBHelper.delete('user_places');
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (e) => Place(
              id: e['id'],
              title: e['title'],
              image: File(e['image']),
              location: PlaceLocation(
                  latitude: e['loc_lat'],
                  longitude: e['loc_lng'],
                  address: e['address'])),
        )
        .toList();
    notifyListeners();
  }
}
