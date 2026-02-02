import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/presentation/router/app_router.dart';

import '../../widgets/date_picker_dialog.dart';

class DailyMealCountStatusScreen extends StatefulWidget {
  const DailyMealCountStatusScreen({super.key});

  @override
  State<DailyMealCountStatusScreen> createState() =>
      _DailyMealCountStatusScreenState();
}

class _DailyMealCountStatusScreenState
    extends State<DailyMealCountStatusScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime lastUpdateTime = DateTime.now();

  final List<CompanyMealData> companies = [
    CompanyMealData(
      name: '대성정밀',
      subtitle: '남품 완료',
      count: 145,
      icon: Icons.business,
    ),
    CompanyMealData(
      name: '한성테크',
      subtitle: '남품 완료',
      count: 98,
      icon: Icons.factory,
    ),
    CompanyMealData(
      name: '유진산업',
      subtitle: '남품 완료',
      count: 210,
      icon: Icons.apartment,
    ),
    CompanyMealData(
      name: '동양기공',
      subtitle: '남품 완료',
      count: 76,
      icon: Icons.domain,
    ),
    CompanyMealData(
      name: '성광건설',
      subtitle: '진행 중',
      count: 320,
      icon: Icons.location_city,
    ),
  ];

  int get totalCount =>
      companies.fold(0, (sum, company) => sum + company.count);

  Future<void> _onRefresh() async {
    // TODO: API call to refresh data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      lastUpdateTime = DateTime.now();
    });
  }

  Future<void> _selectDate() async {
    showDatePickerDialog(
      context,
      initialDate: selectedDate,
      onDateSelected: (date) {
        setState(() {
          selectedDate = date;
        });
      },
    );
  }

  void _navigateToMonthlySettlement() {
    context.push(AppRoutes.monthlySettlement);
  }

  void _navigateToCompanyDetail(CompanyMealData company) {
    context.push(
      AppRoutes.companyMealDetail,
      extra: {
        'companyName': company.name,
        'selectedDate': selectedDate,
      },
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  String _formatUpdateTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? '오후' : '오전';
    return '최근 업데이트: $period $hour:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Body with ScrollToRefresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFF1A2332),
                child: Column(
                  children: [
                    // Dashboard label and update time
                    _buildDashboardHeader(),
                    // Company list (scrollable)
                    Expanded(
                      child: _buildCompanyList(),
                    ),
                    // Total summary (fixed at bottom)
                    _buildTotalSummary(),
                  ],
                ),
              ),
            ),
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
          // Calendar icon
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

          // Selected date
          Text(
            _formatDate(selectedDate),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Document icon
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

  Widget _buildDashboardHeader() {
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

  Widget _buildCompanyList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        return _buildCompanyCard(companies[index]);
      },
    );
  }

  Widget _buildCompanyCard(CompanyMealData company) {
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
            // Icon
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                company.icon,
                color: const Color(0xFF3B82F6),
                size: 28.sp,
              ),
            ),
            SizedBox(width: 8.w),

            // Company info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    company.subtitle,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  company.count.toString(),
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

  Widget _buildTotalSummary() {
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

class CompanyMealData {
  final String name;
  final String subtitle;
  final int count;
  final IconData icon;

  CompanyMealData({
    required this.name,
    required this.subtitle,
    required this.count,
    required this.icon,
  });
}