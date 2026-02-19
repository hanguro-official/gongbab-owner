import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/dashboard/daily_dashboard.dart';
import 'package:gongbab_owner/presentation/router/app_router.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_event.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/daily_meal_count_status/daily_meal_count_status_view_model.dart';
import '../../widgets/date_picker_dialog.dart';

class DailyMealCountStatusScreen extends StatefulWidget {
  const DailyMealCountStatusScreen({super.key});

  @override
  State<DailyMealCountStatusScreen> createState() =>
      _DailyMealCountStatusScreenState();
}

class _DailyMealCountStatusScreenState
    extends State<DailyMealCountStatusScreen> {
  late DailyMealCountStatusViewModel _viewModel;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<DailyMealCountStatusViewModel>();
    _viewModel.addListener(_onViewModelChange);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  void _loadDashboardData() {
    final formattedDate = selectedDate.toIso8601String().split('T').first;
    _viewModel.onEvent(LoadDailyDashboard(
      date: formattedDate,
    ));
  }

  Future<void> _onRefresh() async {
    _loadDashboardData();
  }

  Future<void> _selectDate() async {
    showDatePickerDialog(
      context,
      initialDate: selectedDate,
      onDateSelected: (date) {
        setState(() {
          selectedDate = date;
          _loadDashboardData(); // 날짜 변경 시 데이터 다시 불러오기
        });
      },
    );
  }

  void _navigateToMonthlySettlement() {
    context.push(AppRoutes.monthlySettlement);
  }

  void _navigateToCompanyDetail(DailyDashboardCompany company) {
    context.push(
      AppRoutes.companyMealDetail,
      extra: {
        'companyId': company.companyId,
        'companyName': company.companyName,
        'selectedDate': selectedDate,
      },
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  String _formatUpdateTime(String? time) {
    if (time == null || time.isEmpty) return '최근 업데이트: 정보 없음';

    final dateTime = DateTime.tryParse(time);
    if (dateTime == null) return '최근 업데이트: 정보 없음';

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? '오후' : '오전';
    return '최근 업데이트: $period $hour:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(_viewModel.uiState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(DailyMealCountStatusUiState state) {
    if (state is Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is Error) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (state is Success) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF1A2332),
        child: Column(
          children: [
            _buildDashboardHeader(state.lastUpdateTime),
            Expanded(child: _buildCompanyList(state.companies)),
            _buildTotalSummary(state.companies),
          ],
        ),
      );
    }
    return const SizedBox.shrink(); // Initial state or unknown state
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _selectDate,
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
            _formatDate(selectedDate),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: _navigateToMonthlySettlement,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.description,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader(String? lastUpdateTime) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'DASHBOARD',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '오늘 식사 현황',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _formatUpdateTime(lastUpdateTime),
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(List<DailyDashboardCompany> companies) {
    if (companies.isEmpty) {
      return Center(
        child: Text(
          '아직 식사를 한 업체가 없습니다',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20.sp,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        return _buildCompanyCard(companies[index]);
      },
    );
  }

  Widget _buildCompanyCard(DailyDashboardCompany company) {
    // TODO: 아이콘 API 응답에 따라 수정 필요
    // 현재는 companyName에 따라 임의의 아이콘을 할당
    IconData companyIcon;
    switch (company.companyName) {
      case '대성정밀':
        companyIcon = Icons.business;
        break;
      case '한성테크':
        companyIcon = Icons.factory;
        break;
      case '유진산업':
        companyIcon = Icons.apartment;
        break;
      case '동양기공':
        companyIcon = Icons.domain;
        break;
      case '성광건설':
        companyIcon = Icons.location_city;
        break;
      default:
        companyIcon = Icons.business;
    }

    return GestureDetector(
      onTap: () => _navigateToCompanyDetail(company),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(8.w),
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
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                companyIcon,
                color: const Color(0xFF3B82F6),
                size: 28.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.companyName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${company.meals}식',
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  company.meals.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '식수',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary(List<DailyDashboardCompany> companies) {
    final totalCount = companies.fold(0, (sum, company) => sum + company.meals);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF3B82F6),
          width: 2.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '총 식사 현황',
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '합계',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalCount.toString(),
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  '명',
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
