import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

class WalletHistoryRepo {
  Network network = Network();

  Future<ApiResults> getWalletHistory() async {
    return await network.getData(
      endPoint: URLs.walletHistory,
    );
  }
}
