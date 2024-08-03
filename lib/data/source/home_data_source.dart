import 'package:dio/dio.dart';
import 'package:online_shop/common/http_response_validator.dart';
import 'package:online_shop/data/response/home_response.dart';

abstract class IHomeDatasource {
  Future<HomeResponse> getAll();
}

class HomeRemoteDatasource with HttpResponseValidator implements IHomeDatasource {
  final Dio httpclient;

  HomeRemoteDatasource({required this.httpclient});

  @override
  Future<HomeResponse> getAll() async{
    final res=await httpclient.get('/dashboard');
    validateResponse(res);
   final homeRes=HomeResponse.fromJson(res.data);
   return homeRes;
  }
}
