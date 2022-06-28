class City {
  String cityName;

  static const String city = 'city_name';

  City({required this.cityName});

  static City fromMap(Map<String, Object?> map) =>
      City(cityName: map[city] as String);
}
