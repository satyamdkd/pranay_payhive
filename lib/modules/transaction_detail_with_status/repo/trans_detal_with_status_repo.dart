import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class TransactionDetailWithStatusRepo {
  Network network = Network();

  Future<ApiResults> getTransDetail({
    required String id,
    required String source,
  }) async {
    return await network.getData(
        endPoint:
            '${URLs.transactionDetailWithStatus}?orderid=$id&source=$source');
  }
}
