import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/meal_log/meal_log.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/company_meal_detail/company_meal_detail_view_model.dart';

enum MealType { all, breakfast, lunch, dinner }

extension MealLogItemUIHelpers on MealLogItem {
  MealType get mealTypeEnum {
    switch (mealType) {
      case 'BREAKFAST':
        return MealType.breakfast;
      case 'LUNCH':
        return MealType.lunch;
      case 'DINNER':
        return MealType.dinner;
      default:
        return MealType.all;
    }
  }

  IconData getMealTypeIcon() {
    switch (mealType) {
      case 'BREAKFAST':
        return Icons.wb_sunny_outlined;
      case 'LUNCH':
        return Icons.wb_sunny;
      case 'DINNER':
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }

  Color getMealTypeColor() {
    switch (mealType) {
      case 'BREAKFAST':
        return const Color(0xFFFF9800);
      case 'LUNCH':
        return const Color(0xFFFFC107);
      case 'DINNER':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String getMealTypeLabel() {
    switch (mealType) {
      case 'BREAKFAST':
        return 'BREAKFAST LOGGED';
      case 'LUNCH':
        return 'LUNCH LOGGED';
      case 'DINNER':
        return 'DINNER LOGGED';
      default:
        return 'MEAL LOGGED';
    }
  }
}

class CompanyMealDetailScreen extends StatefulWidget {
  final int companyId;
  final String companyName;
  final DateTime selectedDate;

  const CompanyMealDetailScreen({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.selectedDate,
  });

  @override
  State<CompanyMealDetailScreen> createState() =>
      _CompanyMealDetailScreenState();
}

class _CompanyMealDetailScreenState extends State<CompanyMealDetailScreen> {
  late CompanyMealDetailViewModel _viewModel;

  MealType selectedMealType = MealType.all;
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounce; // For debouncing search input

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<CompanyMealDetailViewModel>();
    _viewModel.addListener(_onViewModelChange);
    // Initial load with current filters
    _loadMealLogs(
      q: searchController.text,
      mealType: selectedMealType,
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    searchController.dispose();
    scrollController.dispose();
    _searchDebounce?.cancel(); // Cancel debounce timer
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  void _loadMealLogs({String? q, MealType? mealType}) {
    final formattedDate =
        widget.selectedDate.toIso8601String().split('T').first;
    _viewModel.onEvent(LoadMealLogs(
      companyId: widget.companyId,
      date: formattedDate,
      q: q,
      mealType: mealType?.toString().split('.').last.toUpperCase(),
    ));
  }

  Future<void> _onRefresh() async {
    // Refresh with current filters
    _loadMealLogs(
      q: searchController.text,
      mealType: selectedMealType,
    );
  }

  List<MealLogItem> get allRecords {
    final state = _viewModel.uiState;
    if (state is Success) {
      return state.mealLog.items;
    }
    return [];
  }

  // Client-side filtering logic is removed. recordsToDisplay will be allRecords
  List<MealLogItem> get recordsToDisplay => allRecords;


  int get breakfastCount {
    final state = _viewModel.uiState;
    if (state is Success) {
      return state.mealLog.items.where((r) => r.mealType == 'BREAKFAST').length;
    }
    return 0;
  }
  int get lunchCount {
    final state = _viewModel.uiState;
    if (state is Success) {
      return state.mealLog.items.where((r) => r.mealType == 'LUNCH').length;
    }
    return 0;
  }
  int get dinnerCount {
    final state = _viewModel.uiState;
    if (state is Success) {
      return state.mealLog.items.where((r) => r.mealType == 'DINNER').length;
    }
    return 0;
  }

  void _loadMore() {
    final state = _viewModel.uiState;
    if (state is! Success) return;

    final nextPage = (allRecords.length / 20).ceil() + 1;

    if (allRecords.length < state.mealLog.totalCount) {
      final formattedDate = widget.selectedDate.toIso8601String().split('T').first;
      _viewModel.onEvent(LoadMoreMealLogs(
        companyId: widget.companyId,
        date: formattedDate,
        page: nextPage,
        q: searchController.text,
        mealType: selectedMealType.toString().split('.').last.toUpperCase(),
      ));
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.year}년 ${date.month}월 ${date.day}일 ($weekday)';
  }

  @override
  Widget build(BuildContext context) {
    final state = _viewModel.uiState;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFixedHeader(),
          Expanded(
            child: (state is Loading && allRecords.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : (state is Error)
                    ? Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: const Color(0xFF3B82F6),
                        backgroundColor: const Color(0xFF1A2332),
                        child: _buildEmployeeList(),
                      ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F1419),
      scrolledUnderElevation: 0,
      elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      title: Text(
        '식수 상세 내역',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      color: const Color(0xFF0F1419),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
            child: Text(
              _formatDate(widget.selectedDate),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildMealSummaryCards(),
          _buildMealTypeTabs(),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildMealSummaryCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _buildMealSummaryCard(
              label: '조식',
              count: breakfastCount,
              icon: Icons.wb_sunny_outlined,
              iconColor: const Color(0xFFFF9800),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildMealSummaryCard(
              label: '중식',
              count: lunchCount,
              icon: Icons.wb_sunny,
              iconColor: const Color(0xFFFFC107),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildMealSummaryCard(
              label: '석식',
              count: dinnerCount,
              icon: Icons.nightlight_round,
              iconColor: const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSummaryCard({
    required String label,
    required int count,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14.sp,
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeTabs() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          _buildTabButton('전체', MealType.all),
          SizedBox(width: 12.w),
          _buildTabButton('조식', MealType.breakfast),
          SizedBox(width: 12.w),
          _buildTabButton('중식', MealType.lunch),
          SizedBox(width: 12.w),
          _buildTabButton('석식', MealType.dinner),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, MealType type) {
    final isSelected = selectedMealType == type;
    return GestureDetector(
      onTap: () {
        selectedMealType = type; // Update local state for UI
        _loadMealLogs(
          q: searchController.text,
          mealType: selectedMealType,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? null
              : Border(
                  bottom: BorderSide(
                    color: const Color(0xFF2D3748),
                    width: 2.h,
                  ),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            _searchDebounce?.cancel(); // Cancel previous debounce
            _searchDebounce = Timer(const Duration(milliseconds: 500), () {
              _loadMealLogs(
                q: value,
                mealType: selectedMealType,
              );
            });
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          decoration: InputDecoration(
            hintText: '임직원 이름 검색...',
            hintStyle: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 15.sp,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: const Color(0xFF6B7280),
              size: 22.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    final uiState = _viewModel.uiState;
    
    // Check if there are no records and not currently loading, and if it's a Success state
    if (uiState is Success) {
      if (recordsToDisplay.isEmpty) {
        String message = (searchController.text.isNotEmpty || selectedMealType != MealType.all)
            ? '검색 결과가 없습니다.'
            : '식사 내역이 없습니다.';
        return Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        );
      }
    }


    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: recordsToDisplay.length + 1 + ( _shouldShowLoadMoreButton() ? 1 : 0), // Header + Records + (LoadMoreButton if visible)
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildListHeader();
        }

        // Load More button at the end
        if (index == recordsToDisplay.length + 1 && _shouldShowLoadMoreButton()) { // Adjusted index calculation for load more button
            return _buildLoadMoreButton();
        }
        
        final record = recordsToDisplay[index - 1]; // -1 because of the header
        return _buildEmployeeRecordCard(record);
      },
    );
  }
  
  bool _shouldShowLoadMoreButton() {
    final state = _viewModel.uiState;
    if (state is Success) {
      // Show load more button if currently loaded items are less than total and not currently loading more
      return state.mealLog.items.length < state.mealLog.totalCount; // simplified
    }
    return false;
  }

  Widget _buildListHeader() {
    final state = _viewModel.uiState;
    int totalCount = 0;
    if (state is Success) {
      totalCount = state.mealLog.totalCount;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '식사 인원 내역',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '총 ${totalCount}건',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRecordCard(MealLogItem record) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF2D3748),
          width: 1.5.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: record.getMealTypeColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              record.getMealTypeIcon(),
              color: record.getMealTypeColor(),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.employeeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  record.getMealTypeLabel(),
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            record.time,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    final state = _viewModel.uiState;
    bool isLoadingMore = false;
    int totalCount = 0;
    if (state is Success) {
      isLoadingMore = state.isLoadingMore;
      totalCount = state.mealLog.totalCount;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: GestureDetector(
        onTap: isLoadingMore ? null : _loadMore,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 2.w,
            ),
          ),
          alignment: Alignment.center,
          child: isLoadingMore 
          ? SizedBox(
            height: 20.h,
            width: 20.h,
            child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B82F6)),
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.refresh,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '상세 내역 더보기 (${allRecords.length}/$totalCount)',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
