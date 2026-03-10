import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettlementDetailScreen extends StatefulWidget {
  final int year;
  final int month;

  const SettlementDetailScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  State<SettlementDetailScreen> createState() => _SettlementDetailScreenState();
}

class _SettlementDetailScreenState extends State<SettlementDetailScreen> {
  // Sample data
  final List<CompanySettlementDetail> companies = [
    CompanySettlementDetail(
      name: '동진레이저',
      mealCount: 183,
      totalAmount: 1281000,
    ),
    CompanySettlementDetail(
      name: '성진',
      mealCount: 40,
      totalAmount: 280000,
    ),
    CompanySettlementDetail(
      name: '현대목공',
      mealCount: 455,
      totalAmount: 3731000,
    ),
  ];

  int get totalAmount =>
      companies.fold(0, (sum, company) => sum + company.totalAmount);

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2332),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white),
                title: Text(
                  '정산 수정',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to edit screen
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  '정산 삭제',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show delete confirmation
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyText() {
    // TODO: Implement copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('텍스트 복사 기능 구현 예정'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _confirmSettlement() {
    // TODO: Implement settlement confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('정산 확정 기능 구현 예정'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  // Company list
                  _buildCompanyList(),

                  SizedBox(height: 24.h),

                  // Total amount section
                  _buildTotalSection(),

                  SizedBox(height: 120.h), // Space for bottom buttons
                ],
              ),
            ),
          ),

          // Bottom action buttons
          _buildBottomActions(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F1419),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '${widget.year}년 ${widget.month}월 정산',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '거래처별 정산 내역',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 16.sp,
            ),
          ),
          Text(
            '${companies.length}건',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: Column(
          children: companies
              .asMap()
              .entries
              .map((entry) => _buildCompanyItem(
            entry.value,
            isLast: entry.key == companies.length - 1,
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCompanyItem(CompanySettlementDetail company,
      {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${company.mealCount}식',
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_formatCurrency(company.totalAmount)}원',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              height: 1.h,
              color: const Color(0xFF2D3748),
            ),
          ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '총 정산 금액',
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '합계 ',
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 20.sp,
                ),
              ),
              Text(
                _formatCurrency(totalAmount),
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h, left: 4.w),
                child: Text(
                  '원',
                  style: TextStyle(
                    color: const Color(0xFF3B82F6),
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: const Color(0xFF0F1419),
      child: Row(
        children: [
          // Copy text button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _copyText,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3748),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.content_copy,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '텍스트 복사',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Confirm settlement button
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: _confirmSettlement,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '정산 확정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanySettlementDetail {
  final String name;
  final int mealCount;
  final int totalAmount;

  CompanySettlementDetail({
    required this.name,
    required this.mealCount,
    required this.totalAmount,
  });
}