import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Album> createAlbum(String name,String phone,String latitude, String longitude) async {
  final http.Response response = await http.post(
    'http://34.71.91.164/registeringinfo',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String name;
  final String phone;
  final String place;

  Album({this.name, this.phone, this.place});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      phone: json['phone'],
      place: json['place'],
    );
  }
}