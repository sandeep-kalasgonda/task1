import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task1/JsonModels/users.dart';

class DatabaseHelper {
  final databaseName = "notes.db";
  late Database _database;

  // Define the table schema for the 'users' table
  String userTable =
      "CREATE TABLE users (userid INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, password TEXT NOT NULL, email TEXT NOT NULL, phone TEXT NOT NULL)";

  // Initialize the database and create the 'users' table if it doesn't exist
  Future<void> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    _database = await openDatabase(path, version: 1,
        onCreate: (db, version) async {
          await db.execute(userTable); // Create the 'users' table
        });
  }

  // Login Method
  Future<bool> login(String username, String password) async {
    await initDB(); // Ensure database is initialized
    var result = await _database.rawQuery(
        "SELECT * FROM users WHERE username = '$username' AND password = '$password'");
    return result.isNotEmpty; // Return true if a user with matching credentials exists
  }

  // Sign Up Method
  Future<int> signup(Users user) async {
    await initDB(); // Ensure database is initialized
    return _database.insert('users', user.toMap()); // Insert the user into the 'users' table
  }

  // Update User Data using GraphQL Mutation
  Future<void> updateUser({
    required String userId,
    required String newEmail,
    required String newPhone,
    required GraphQLClient client,
  }) async {
    final String updateUserMutation = r'''
      mutation UpdateUser($userId: ID!, $newEmail: String!, $newPhone: String!) {
        updateUser(id: $userId, email: $newEmail, phone: $newPhone) {
          id
          username
          email
          phone
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(updateUserMutation),
      variables: {
        'userId': userId,
        'newEmail': newEmail,
        'newPhone': newPhone,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print('Error updating user data: ${result.exception.toString()}');
    } else {
      print('User data updated successfully');
      // Optionally, you can update the UI or show a success message
    }
  }
}
