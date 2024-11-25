import 'dart:convert';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/core/failure/failure.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await http.post(
          Uri.parse("${ServerConstant.serverURL}/auth/signup"),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({'name': name, 'email': email, 'password': password}));
      // print(response.body);
      // print(response.statusCode);
      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle the error
        return Left(AppFailure(responseBodyMap['detail']));
      }
      return Right(UserModel.fromMap(responseBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
          Uri.parse("${ServerConstant.serverURL}/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}));
      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(responseBodyMap['detail']));
      }
      return Right(UserModel.fromMap(responseBodyMap));
      // print(response.body);
      // print(response.statusCode);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
