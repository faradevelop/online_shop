import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/response/home_response.dart';
import 'package:online_shop/data/source/home_data_source.dart';

final homeRepository =
    HomeRepository(HomeRemoteDatasource(httpclient: httpClient));

abstract class IHomeRepository {
  Future<HomeResponse> getAll();
}

class HomeRepository implements IHomeRepository {
  final IHomeDatasource dataSource;

  HomeRepository(this.dataSource);

  @override
  Future<HomeResponse> getAll() {
    return dataSource.getAll();
  }
}
