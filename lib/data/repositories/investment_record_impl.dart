import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/investiment_record.dart';
import '../../domain/repositories/investiment_record_repository.dart';

class InvestmentRecordRepositoryImpl implements InvestmentRecordRepository {
  @override
  Future<List<InvestmentRecord>> getAllInvestmentRecord(
    String? filter,
    bool ascending,
  ) async {
    try {
      var url = 'http://localhost:8080/getAllInvestment?ascending=$ascending';

      if (filter != null) {
        url += '&filter=$filter';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body);

      return ((data['records'] as List?) ?? [])
          .map((e) => InvestmentRecord.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar investimentos: $e');
    }
  }

  @override
  Future<bool> saveInvestmentRecord({required InvestmentRecord record}) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/saveInvestment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      throw Exception(
        'Erro ao salvar investimento. Status: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Erro ao salvar investimento: $e');
    }
  }

  @override
  Future<InvestmentRecord> dataDashboard(String? filter) async {
    try {
      var url = 'http://localhost:8080/dataDashboard';

      if (filter != null) {
        url += '?filter=$filter';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body);

      return InvestmentRecord.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar dados da dashboard: $e');
    }
  }

  @override
  Future<List<AssetsGrowth>> assetGrowth(String? filter) async {
    try {
      var url = 'http://localhost:8080/assetGrowth';

      if (filter != null) {
        url += '?filter=$filter';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body);

      return ((data as List?) ?? [])
          .map((e) => AssetsGrowth.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar dados da dashboard: $e');
    }
  }

  @override
  Future<List<CategoryGrowth>> categoryGrowth(String? filter) async {
    try {
      var url = 'http://localhost:8080/categoryGrowth';

      if (filter != null) {
        url += '?filter=$filter';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body);

      return ((data as List?) ?? [])
          .map((e) => CategoryGrowth.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception(
        'Erro ao buscar dados do gráfico evolução por categoria: $e',
      );
    }
  }

  @override
  Future<List<int>> availableYears() async {
    try {
      var url = 'http://localhost:8080/availableYears';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body) as List?;

      return data?.cast<int>() ?? [];
    } catch (e) {
      throw Exception(
        'Erro ao buscar dados do gráfico evolução por categoria: $e',
      );
    }
  }

  @override
  Future<InvestmentRecord?> getLastInvestmentRecord() async {
    try {
      var url = 'http://localhost:8080/lastInvestmentRecord';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = jsonDecode(response.body);

      if (data == null) {
        return null;
      }


      return  InvestmentRecord.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar getLastInvestmentRecord: $e');
    }
  }
}
