import 'dart:convert';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/core/failure/failure.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await http.post(
          Uri.parse("http://10.0.2.2:8000/auth/signup"),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({'name': name, 'email': email, 'password': password}));
      print(response.body);
      print(response.statusCode);
      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle the error
        return Left(AppFailure(responseBodyMap['details']));
      }
      return Right(
          UserModel(name: name, email: email, id = responseBodyMap['id']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
          Uri.parse("http://10.0.2.2:8000/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
