import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for managing the current user state
final userProvider = StateProvider<User>((ref) => User());

class User {
  String name;
  String email;

  User({this.name = '', this.email = ''});
}
