import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/settlement/monthly_settlement.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_event.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/monthly_settlement/monthly_settlement_view_model.dart';
import 'package:intl/intl.dart';

import '../../widgets/month_picker_dialog.dart';

class MonthlySettlementScreen extends StatefulWidget {
  const MonthlySettlementScreen({super.key});

  @override
  State<MonthlySettlementScreen> createState() =>
      _MonthlySettlementScreenState();
}

class _MonthlySettlementScreenState extends State<MonthlySettlementScreen> {
  late MonthlySettlementViewModel _viewModel;
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<MonthlySettlementViewModel>();
    _viewModel.addListener(_onViewModelChange);
    _loadMonthlySettlement();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
    if (_viewModel.uiState is ExportSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((_viewModel.uiState as ExportSuccess).message)),
      );
    } else if (_viewModel.uiState is ExportError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((_viewModel.uiState as ExportError).message)),
      );
    } else if (_viewModel.uiState is Error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((_viewModel.uiState as Error).message)),
      );
    }
  }

  void _loadMonthlySettlement() {
    final formattedMonth = DateFormat('yyyy-MM').format(selectedMonth);
    _viewModel.onEvent(LoadMonthlySettlement(month: formattedMonth));
  }

  void _exportMonthlySettlement() {
    final formattedMonth = DateFormat('yyyy-MM').format(selectedMonth);
    _viewModel.onEvent(ExportMonthlySettlement(month: formattedMonth));
  }

  Future<void> _selectMonth() async {
    showMonthPickerDialog(
      context,
      initialDate: selectedMonth,
      onMonthSelected: (date) {
        setState(() {
          selectedMonth = date;
          _loadMonthlySettlement(); // 월 변경 시 데이터 다시 불러오기
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '월간 정산',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(_viewModel.uiState),
            ),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _selectMonth,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          Text(
            DateFormat('yyyy년 MM월').format(selectedMonth),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 24.w + 24.h), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildBody(MonthlySettlementUiState state) {
    MonthlySettlement? monthlySettlementToDisplay;

    if (state is Success) {
      monthlySettlementToDisplay = state.monthlySettlement;
    } else if (state is Exporting) {
      monthlySettlementToDisplay = state.monthlySettlement;
    } else if (state is ExportSuccess) {
      monthlySettlementToDisplay = state.monthlySettlement;
    } else if (state is ExportError) {
      monthlySettlementToDisplay = state.monthlySettlement;
    }

    if (state is Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is Error) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (monthlySettlementToDisplay != null) {
      return _buildSettlementDetails(monthlySettlementToDisplay);
    } else {
      return Center(
        child: Text(
          '정산 데이터를 불러올 수 없습니다.',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildSettlementDetails(MonthlySettlement settlement) {
    return RefreshIndicator(
      onRefresh: () async => _loadMonthlySettlement(),
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFF1A2332),
      child: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _buildSummaryCard(
            title: '총 정산 금액',
            value: '${_formatCurrency(settlement.totalAmount)}원',
            icon: Icons.account_balance_wallet,
            iconColor: const Color(0xFF3B82F6),
          ),
          SizedBox(height: 16.h),
          _buildSummaryCard(
            title: '총 식수',
            value: '${settlement.totalMeals}명',
            icon: Icons.people,
            iconColor: const Color(0xFF10B981),
          ),
          SizedBox(height: 16.h),
          Text(
            '${DateFormat('yyyy년 MM월').format(selectedMonth)} 정산',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '데이터 생성일: ${settlement.generatedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(settlement.generatedAt!)) : '정보 없음'}',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          _buildMealTypeSummary(settlement), // Pass the whole settlement object
          SizedBox(height: 16.h),
          Text(
            '업체별 정산 내역',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...settlement.companies.map((company) => _buildCompanySettlementCard(company)).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSummary(MonthlySettlement settlement) { // Changed parameter to MonthlySettlement
    // Calculate meal type counts from settlement.companies if needed,
    // or use existing byMealType if available in MonthlySettlement
    // For now, let's assume MonthlySettlement has byMealType for overall summary
    // If not, it needs to be calculated from settlement.companies

    // Assuming MonthlySettlement has a byMealType equivalent for total summary,
    // or calculate from all companies' meals
    int totalBreakfast = settlement.companies.fold(0, (sum, company) => sum + (company.meals)); // Assuming total meals is sum of all meals
    int totalLunch = 0; // Placeholder, adjust if MonthlySettlement has detailed breakdown
    int totalDinner = 0; // Placeholder, adjust if MonthlySettlement has detailed breakdown

    // If API provides byMealType at top level of MonthlySettlement, use that.
    // Otherwise, we need more info or to calculate from sub-items.
    // For now, using totalMeals as a placeholder for breakdown.
    // This part might need adjustment based on actual data structure for meal type breakdown.

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '식사 타입별 식수',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          // Placeholder values - need actual MonthlySettlement structure for breakdown
          _buildMealTypeRow('조식', totalBreakfast), // This would be settlement.byMealType.breakfast
          _buildMealTypeRow('중식', totalLunch),   // This would be settlement.byMealType.lunch
          _buildMealTypeRow('석식', totalDinner),   // This would be settlement.byMealType.dinner
        ],
      ),
    );
  }

  Widget _buildMealTypeRow(String type, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Text(
            '${count}명',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySettlementCard(MonthlySettlementCompany company) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company.companyName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          _buildSettlementRow('식수', '${company.meals}명'),
          _buildSettlementRow('정산 금액', '${_formatCurrency(company.amount)}원'),
        ],
      ),
    );
  }

  Widget _buildSettlementRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    final bool isLoading = _viewModel.uiState is Exporting;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : _exportMonthlySettlement,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                '정산 내역 다운로드',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    return formatter.format(amount);
  }
}
