import '../entities/investiment_record.dart';
import '../repositories/investiment_record_repository.dart';

class InvestmentRecordUseCase {
  final InvestmentRecordRepository repository;

  InvestmentRecordUseCase(this.repository);

  Future<List<InvestmentRecord>> getAllInvestmentRecord(
    String? filter,
    bool ascending,
  ) async {
    return repository.getAllInvestmentRecord(filter, ascending);
  }

  Future<bool> saveInvestmentRecord({required InvestmentRecord record}) {
    return repository.saveInvestmentRecord(record: record);
  }

  Future<InvestmentRecord> dataDashboard(String? filter) {
    return repository.dataDashboard(filter);
  }

  Future<List<AssetsGrowth>> assetGrowth(String? filter) {
    return repository.assetGrowth(filter);
  }

  Future<List<CategoryGrowth>> categoryGrowth(String? filter) {
    return repository.categoryGrowth(filter);
  }

  Future<List<int>> availableYears() {
    return repository.availableYears();
  }

  Future<InvestmentRecord?> getLastInvestmentRecord() {
    return repository.getLastInvestmentRecord();
  }
}
