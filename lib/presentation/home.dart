import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/repositories/investment_record_impl.dart';
import '../domain/entities/investiment_record.dart';
import '../domain/usecases/investiment_record_use_case.dart';
import '../util/app_colors.dart';
import '../util/button_click_customized.dart';
import '../util/button_customized.dart';
import '../util/chart_asset_growth.dart';
import '../util/chart_category_growth.dart';
import '../util/filter_dropdown.dart';
import '../util/flush_bar.dart';
import '../util/formatter.dart';
import '../util/modal_customized.dart';
import '../util/text_form_customized.dart';
import '../util/text_style.dart';

class DashboardState with ChangeNotifier {
  DashboardState({required this.useCase}) {
    main();
  }

  InvestmentRecordUseCase useCase;

  final months = {
    'Todos os meses': null,
    'Janeiro': 1,
    'Fevereiro': 2,
    'Março': 3,
    'Abril': 4,
    'Maio': 5,
    'Junho': 6,
    'Julho': 7,
    'Agosto': 8,
    'Setembro': 9,
    'Outubro': 10,
    'Novembro': 11,
    'Dezembro': 12,
  };

  String? monthNextDate;
  String? yearCurrentOrNextDate;
  DateTime dateToRecord = DateTime.now();

  TextEditingController emergency = TextEditingController();
  TextEditingController fixedIncome = TextEditingController();
  TextEditingController variableIncome = TextEditingController();
  TextEditingController contribution = TextEditingController();

  List<InvestmentRecord> investmentsRecord = [];

  int lengthRecord = 0;

  bool loading = false;

  bool _ascending = true;

  String? filter = (DateTime.now().year).toString();

  String? selectYear = (DateTime.now().year).toString();

  String allYears = 'Todos os anos';

  int? selectMonth;

  List<AssetsGrowth> assetsGrowth = [];

  List<CategoryGrowth> categoryGrowth = [];

  List<int> availableYears = [];

  InvestmentRecord? _dataDashboard;

  InvestmentRecord? get dataDashboard => _dataDashboard;

  set dataDashboard(InvestmentRecord value) {
    _dataDashboard = value;
  }

  bool get ascending => _ascending;

  set ascending(bool value) {
    _ascending = value;
    notifyListeners();
  }

  Future<void> main() async {
    await reloadDashboard();
  }

  Future<void> reloadDashboard() async {
    try {
      loading = true;
      notifyListeners();
      dataDashboard = await useCase.dataDashboard(filter);
      await  callGetAllInvestmentRecord();
      assetsGrowth = await useCase.assetGrowth(filter);
      categoryGrowth = await useCase.categoryGrowth(filter);
      availableYears = await useCase.availableYears();
      lengthRecord = investmentsRecord.length;

      _fillFieldsOfLastRecords();
    } catch (e) {
      throw Exception('Erro ao buscar investimentos: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future callGetAllInvestmentRecord() async {
    investmentsRecord = await useCase.getAllInvestmentRecord(filter, ascending);
    notifyListeners();
  }

  Future<bool> saveInvestmentRecord({int? id}) async {
    var record = InvestmentRecord(
      id: id,
      date: dateToRecord,
      emergency: double.parse(
        emergency.text
            .replaceAll(RegExp(r'[^\d,.-]'), '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ),
      fixedIncome: double.parse(
        fixedIncome.text
            .replaceAll(RegExp(r'[^\d,.-]'), '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ),
      variableIncome: double.parse(
        variableIncome.text
            .replaceAll(RegExp(r'[^\d,.-]'), '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ),
      contribution: double.parse(
        contribution.text
            .replaceAll(RegExp(r'[^\d,.-]'), '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim(),
      ),
    );

    var result = await useCase.saveInvestmentRecord(record: record);

    return result;
  }

  void cleanFields() {
    emergency.clear();
    fixedIncome.clear();
    variableIncome.clear();
    contribution.clear();
  }

  bool isValid() {
    return emergency.text.isNotEmpty &&
        fixedIncome.text.isNotEmpty &&
        variableIncome.text.isNotEmpty &&
        contribution.text.isNotEmpty;
  }

  Future<void> _fillFieldsOfLastRecords() async {
    final lastInvestmentRecord = await useCase.getLastInvestmentRecord();
    DateTime? itemDate;

    if (lastInvestmentRecord != null) {
      var item = lastInvestmentRecord;
      emergency.text = formatCurrency(item.emergency);
      fixedIncome.text = formatCurrency(item.fixedIncome);
      variableIncome.text = formatCurrency(item.variableIncome);
      contribution.text = formatCurrency(item.contribution);
      itemDate = item.date;
    }

    dateToRecord = itemDate != null
        ? DateTime(itemDate.year, itemDate.month + 1, itemDate.day)
        : DateTime.now();

    monthNextDate = months.entries
        .firstWhere((entry) => entry.value == dateToRecord.month)
        .key;

    yearCurrentOrNextDate = dateToRecord.year.toString();
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(child: _Dashboard()));
  }
}

class _Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardState(
        useCase: InvestmentRecordUseCase(InvestmentRecordRepositoryImpl()),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              Text('Meu Patrimônio', style: TextStyle(fontSize: 24)),
              _CardDashboard(),
              _CardFilter(context),
              _CardRegisterHistory(),
              _CardsRowsChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();
    final data = state._dataDashboard;
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _CardItemDashboard(
            backgroundIcon: AppColors.greySoft,
            colorIcon: AppColors.grey,
            label: 'Patrimônio',
            value: formatCurrencyWithoutSymbol(data?.total ?? 0),
            subtitle: 'Total acumulado',
            icon: Icons.wallet_outlined,
          ),
        ),
        Expanded(
          child: _CardItemDashboard(
            backgroundIcon: AppColors.redSoft,
            colorIcon: AppColors.red,
            label: 'Reserva de emergência',
            value: formatCurrencyWithoutSymbol(data?.emergency ?? 0),
            subtitle: 'Liquidez diária',
            icon: Icons.warning_amber,
          ),
        ),
        Expanded(
          child: _CardItemDashboard(
            backgroundIcon: AppColors.greenSoft,
            colorIcon: AppColors.green,
            label: 'Renda Fixa',
            value: formatCurrencyWithoutSymbol(data?.fixedIncome ?? 0),
            subtitle: 'CDBs, Tesouro, LCI',
            icon: Icons.safety_check_outlined,
          ),
        ),
        Expanded(
          child: _CardItemDashboard(
            backgroundIcon: AppColors.blueSoft,
            colorIcon: AppColors.blue,
            label: 'Renda variável',
            value: formatCurrencyWithoutSymbol(data?.variableIncome ?? 0),
            subtitle: 'Ações, FIIs, ETFs',
            icon: Icons.ssid_chart,
          ),
        ),
      ],
    );
  }
}

class _CardItemDashboard extends StatelessWidget {
  const _CardItemDashboard({
    required this.backgroundIcon,
    required this.colorIcon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color backgroundIcon;
  final Color colorIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: AppTextStyles.label,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: backgroundIcon,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(icon, color: colorIcon),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(value, style: AppTextStyles.value),
          Text(subtitle, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}

class _CardFilter extends StatelessWidget {
  const _CardFilter(this.ctx);

  final BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !state.loading
              ? Row(
                  spacing: 15,
                  children: [
                    Text('Filtros', style: AppTextStyles.label),
                    SizedBox(
                      width: 150,
                      child: FilterDropdown<String>(
                        value: state.selectYear ?? state.allYears,
                        items: state.availableYears.isEmpty
                            ? []
                            : [state.allYears, ...state.availableYears].map((
                                e,
                              ) {
                                return e.toString();
                              }).toList(),
                        onChanged: (value) {
                          if (value == state.allYears) {
                            state.selectYear = null;
                            state.selectMonth = null;
                          } else {
                            state.selectYear = value!;
                          }
                          if (state.selectMonth == null) {
                            state.filter = state.selectYear;
                            state.reloadDashboard();
                          } else {
                            state.filter =
                                '${state.selectYear}-${state.selectMonth.toString().padLeft(2, '0')}';
                            state.reloadDashboard();
                          }
                        },
                      ),
                    ),
                    if (state.selectYear != null)
                      SizedBox(
                        width: 200,
                        child: FilterDropdown<String>(
                          value: state.selectMonth != null
                              ? state.months.entries
                                    .firstWhere(
                                      (entries) =>
                                          entries.value == state.selectMonth,
                                    )
                                    .key
                              : 'Todos os meses',
                          items: state.months.keys.toList(),
                          onChanged: (value) {
                            state.selectMonth = state.months[value];

                            if (state.selectMonth == null) {
                              state.filter = state.selectYear;
                              state.reloadDashboard();
                            } else {
                              state.filter =
                                  '${state.selectYear}-${state.selectMonth.toString().padLeft(2, '0')}';
                              state.reloadDashboard();
                            }
                          },
                        ),
                      ),
                  ],
                )
              : Spacer(),

          ButtonCustomized(
            onPressed: () {
              showInvestmentModal(
                context,
                state: state,
                title:
                    'Novo registro — ${state.monthNextDate}/${state.yearCurrentOrNextDate}',
                subtitle:
                    'Atualize os valores do mês. O aporte é apenas informativo do quanto foi aplicado.',
                successMessage: 'Registro salvo com sucesso!',
                errorMessage: 'Erro ao salvar registro!',
              );
            },
            label: 'Novo registro',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

class _CardRegisterHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Histórico de patrimônio',
            style: AppTextStyles.label.copyWith(color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Registros mensais das três classes que compõem o total.',
                style: AppTextStyles.subtitle,
              ),

              Row(
                spacing: 20,
                children: [
                  if (state.selectMonth == null)
                    ButtonClickCustomized(
                      label: state.ascending ? 'Mais antigo' : 'Mais recente',
                      icon: Icons.swap_vert_outlined,
                      onPressed: () {
                        state.ascending = !state.ascending;
                        state.callGetAllInvestmentRecord();
                      },
                    ),
                  Text(
                    '${state.lengthRecord} Registros',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ],
          ),
          DataTableRegister(),
        ],
      ),
    );
  }
}

class DataTableRegister extends StatelessWidget {
  const DataTableRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();
    return SizedBox(
      width: double.infinity,
      child: state.loading == true
          ? Center(child: CircularProgressIndicator())
          : state.lengthRecord == 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Nenhum histórico de patrimônio',
                  style: AppTextStyles.label,
                ),
              ),
            )
          : _ContentTableRegister(),
    );
  }
}

class _ContentTableRegister extends StatelessWidget {
  const _ContentTableRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();
    return DataTable(
      showBottomBorder: true,
      showCheckboxColumn: true,
      columnSpacing: 0,
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(child: Text('Data', style: AppTextStyles.label)),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Emergência', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Renda Fixa', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Renda	Variável', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Aporte', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Variação', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text('Total', style: AppTextStyles.label),
            ),
          ),
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,
          label: Text('', style: AppTextStyles.label),
        ),
      ],
      rows: state.investmentsRecord.map((investment) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                formatMonthYear(investment.date ?? DateTime.now()),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.emergency),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.fixedIncome),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.variableIncome),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.contribution),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.variation ?? 0),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  formatCurrency(investment.total ?? 0),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataCell(
              Align(
                alignment: Alignment.centerRight,
                child: Tooltip(
                  preferBelow: false,
                  message:
                      'Editar ${formatMonthYear(investment.date ?? DateTime.now())}',

                  decoration: BoxDecoration(
                    color: Color(0xFF7E8A9A),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: 30,
                    height: 30,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      hoverColor: const Color(0xFFE3E6EA),
                      splashColor: const Color(0xFFD5DAE0),
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () {
                        state.dateToRecord = investment.date!;
                        state.emergency = TextEditingController(
                          text: formatCurrency(investment.emergency),
                        );
                        state.fixedIncome = TextEditingController(
                          text: formatCurrency(investment.fixedIncome),
                        );
                        state.variableIncome = TextEditingController(
                          text: formatCurrency(investment.variableIncome),
                        );
                        state.contribution = TextEditingController(
                          text: formatCurrency(investment.contribution),
                        );
                        showInvestmentModal(
                          state: state,
                          context,
                          title:
                              'Editar registro — ${formatMonthYear(investment.date ?? DateTime.now())}',
                          subtitle:
                              'Atualize os valores desse mês. O aporte é apenas informativo do quanto foi aplicado.',
                          successMessage: 'Registro alterado com sucesso!',
                          errorMessage: 'Erro ao alterar registro!',
                          id: investment.id,
                        );
                      },
                      child: Icon(
                        Icons.mode_edit_outline_outlined,
                        size: 20,
                        color: Color(0xFF5F6F8C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

void showInvestmentModal(
  BuildContext context, {
  required DashboardState state,
  required String title,
  required String subtitle,
  required String successMessage,
  required String errorMessage,
  int? id,
}) {
  modalCustomized(
    context,
    content: KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          await _saveInvestment(
            context,
            id: id,
            state: state,
            successMessage: successMessage,
            errorMessage: errorMessage,
          );
        }
      },
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.label.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(subtitle, style: AppTextStyles.subtitle),
            ],
          ),

          TextFormCustomized(
            controller: state.emergency,
            label: 'Reserva de emergência (R\$)',
          ),

          TextFormCustomized(
            controller: state.fixedIncome,
            label: 'Renda fixa (R\$)',
          ),

          TextFormCustomized(
            controller: state.variableIncome,
            label: 'Renda variável (R\$)',
          ),

          TextFormCustomized(
            controller: state.contribution,
            label: 'Aportes mensais (R\$)',
          ),

          const SizedBox(height: 1),

          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              ButtonCustomized(
                secondary: true,
                onPressed: () {
                  state.cleanFields();
                  Navigator.pop(context);
                },
                label: 'Voltar',
                icon: Icons.arrow_back_outlined,
              ),

              ButtonCustomized(
                onPressed: () async {
                  await _saveInvestment(
                    context,
                    id: id,
                    state: state,
                    successMessage: successMessage,
                    errorMessage: errorMessage,
                  );
                },
                label: 'Salvar',
                icon: Icons.save_outlined,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> _saveInvestment(
  BuildContext context, {
  int? id,
  required DashboardState state,
  required String successMessage,
  required String errorMessage,
}) async {
  if (!state.isValid()) {
    FlushBarUtil.show(
      context: context,
      message: 'Preencher todos os campos!',
      color: Colors.red,
    );

    return;
  }

  final result = await state.saveInvestmentRecord(id: id);

  if (!context.mounted) return;

  Navigator.pop(context);

  state.reloadDashboard();

  if (result == true && context.mounted) {
    FlushBarUtil.show(
      context: context,
      message: successMessage,
      color: Colors.green,
    );
  } else {
    FlushBarUtil.show(
      context: context,
      message: errorMessage,
      color: Colors.red,
    );
  }
}

class _CardsRowsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardState>();
    return (MediaQuery.of(context).size.width > 1200)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: [
              Expanded(
                child: _ContentChart(
                  label: 'Evolução do patrimônio',
                  subtitle: 'Soma das três classes ao longo do tempo.',
                  content: FinancialEvolutionChart(
                    evolutions: state.assetsGrowth,
                    loading: state.loading,
                  ),
                ),
              ),

              Expanded(
                child: _ContentChart(
                  label: 'Evolução por categoria',
                  subtitle:
                      'Comparativo mensal entre Emergência, Renda Fixa e Variável.',
                  content: FinancialBarChart(
                    evolutions: state.categoryGrowth,
                    loading: state.loading,
                  ),
                ),
              ),
            ],
          )
        : Column(
            spacing: 15,
            children: [
              _ContentChart(
                label: 'Evolução do patrimônio',
                subtitle: 'Soma das três classes ao longo do tempo.',
                content: FinancialEvolutionChart(
                  evolutions: state.assetsGrowth,
                  loading: state.loading,
                ),
              ),
              _ContentChart(
                label: 'Evolução por categoria',
                subtitle:
                    'Comparativo mensal entre Emergência, Renda Fixa e Variável.',
                content: FinancialBarChart(
                  evolutions: state.categoryGrowth,
                  loading: state.loading,
                ),
              ),
            ],
          );
  }
}

class _ContentChart extends StatelessWidget {
  const _ContentChart({
    required this.label,
    required this.subtitle,
    required this.content,
  });

  final String label;
  final String subtitle;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(color: Colors.black)),
          Text(subtitle, style: AppTextStyles.subtitle),
          content,
        ],
      ),
    );
  }
}
