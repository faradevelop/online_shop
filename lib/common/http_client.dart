import 'package:dio/dio.dart';
import 'package:online_shop/data/repository/auth_repository.dart';

final httpClient = Dio(BaseOptions(baseUrl: ''))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.token.isNotEmpty) {
        if (authInfo.token.isNotEmpty) {
          options.headers["Authorization"] = 'Bearer ${authInfo.token}';
        }
      }
      handler.next(options);
    },
  ));
