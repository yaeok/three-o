import 'package:three_o/domain/model/usage/usage.dart';

// ドメイン層のインターフェース
abstract class UsageRepository {
  Future<Usage> getUsage(String userId);
  Future<void> updateUsage(Usage usage);
}
