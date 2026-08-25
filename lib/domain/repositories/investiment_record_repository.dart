import '../entities/investiment_record.dart';

abstract class InvestmentRecordRepository {
  Future<List<InvestmentRecord>> getAllInvestmentRecord(
    String? filter,
    bool ascending,
  );

  Future<bool> saveInvestmentRecord({required InvestmentRecord record});

  Future<InvestmentRecord> dataDashboard(String? filter);

  Future<List<AssetsGrowth>> assetGrowth(String? filter);

  Future<List<CategoryGrowth>> categoryGrowth(String? filter);

  Future<List<int>> availableYears();

  Future<InvestmentRecord?> getLastInvestmentRecord();
}
