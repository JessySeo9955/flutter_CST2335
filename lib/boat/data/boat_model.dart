import 'package:floor/floor.dart';

/// Boat entity for database storage
@entity
class Boat {
  /// Database auto-incremented primary key
  @primaryKey
  final int? id;

  /// Address field - stores boat location
  final String address;

  /// Price field - stores boat sale price
  final String price;

  /// Power type field - motor or sail
  final String powerType;

  /// Boat length measurement
  final String boatLength;

  /// Year boat was manufactured
  final String yearBuilt;

  /// Constructor for Boat objects
  Boat({
    this.id,
    required this.address,
    required this.price,
    required this.powerType,
    required this.boatLength,
    required this.yearBuilt,
  });
}

