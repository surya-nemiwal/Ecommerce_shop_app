import 'package:flutter/rendering.dart';

class FavoriteException implements Exception{
  @override
  String toString() {
    // TODO: implement toString
    return 'unable to change favorite';
  }
}