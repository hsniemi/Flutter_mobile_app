class Place {
  final int? id;
  final String? date;
  final String title;
  final String? description;
  final double latitude;
  final double longitude;

  Place({
    required this.title,
    this.id,
    this.date,
    this.description,
    required this.latitude,
    required this.longitude,
  });

  Place copy({
    int? id,
    String? date,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
  }) =>
      Place(
        id: id ?? this.id,
        date: date ?? this.date,
        title: title ?? this.title,
        description: description ?? this.description,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  Map<String, Object?> toMap() => {
        PlaceField.id: id,
        PlaceField.date: date,
        PlaceField.title: title,
        PlaceField.description: description,
        PlaceField.latitude: latitude,
        PlaceField.longitude: longitude,
      };

  static Place fromMap(Map<String, Object?> map) => Place(
        id: map[PlaceField.id] as int?,
        date: map[PlaceField.date] as String,
        title: map[PlaceField.title] as String,
        description: map[PlaceField.description] as String,
        latitude: map[PlaceField.latitude] as double,
        longitude: map[PlaceField.longitude] as double,
      );

  @override
  String toString() {
    return 'id: $id, date: $date, title: $title, description: $description, latitude: $latitude, longitude: $longitude.';
  }
}

const String place = 'place';
const String location = 'location';

class PlaceField {
  static final List<String> values = [
    id,
    date,
    title,
    description,
    latitude,
    longitude,
  ];
  static const String id = '_id';
  static const String date = 'date';
  static const String title = 'title';
  static const String description = 'description';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
}
