
import 'package:injectable/injectable.dart';

import 'app_api_client.dart';

@singleton
class ApiService {
  final AppApiClient _appApiClient;

  ApiService(this._appApiClient);



}