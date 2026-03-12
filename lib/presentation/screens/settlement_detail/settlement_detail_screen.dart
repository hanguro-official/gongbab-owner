import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_view_model.dart';
import 'package:gongbab_owner/presentation/widgets/custom_alert_dialog.dart';

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
  late SettlementDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<SettlementDetailViewModel>();
    _viewModel.addListener(_onViewModelChange);
    _loadDetail();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  void _onViewModelChange() {
    if (_viewModel.errorMessage != null) {
      _showErrorDialog(_viewModel.errorMessage!);
      _viewModel.clearError();
    }
  }

  void _loadDetail() {
    _viewModel.onEvent(LoadSettlementDetail(
      year: widget.year,
      month: widget.month,
    ));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: '정산 확정 실패',
        content: message,
        rightButtonText: '확인',
        onRightButtonPressed: () {},
      ),
    );
  }

  void _copyText(Settlement settlement) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('[${settlement.year}년 ${settlement.month}월 정산]');

    if (settlement.items != null) {
      for (final item in settlement.items!) {
        buffer.writeln('${item.companyName} ${_formatCurrency(item.supplyAmount)}원');
      }
    }

    buffer.write('총 합계 ${_formatCurrency(settlement.totalSupplyAmount)}원');

    Clipboard.setData(ClipboardData(text: buffer.toString())).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('정산 내역이 복사되었습니다.'),
            backgroundColor: Color(0xFF3B82F6),
          ),
        );
      }
    });
  }

  void _showConfirmDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: '정산을 확정하시겠어요?',
        content: '확정한 뒤에는 수정할 수 없어요',
        leftButtonText: '취소',
        onLeftButtonPressed: () {},
        rightButtonText: '확정',
        onRightButtonPressed: () {
          _viewModel.onEvent(ConfirmSettlement(id));
        },
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return _buildBody(_viewModel.uiState);
        },
      ),
    );
  }

  Widget _buildBody(SettlementDetailUiState state) {
    if (state is SettlementDetailLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
      );
    }

    if (state is SettlementDetailError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadDetail,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state is SettlementDetailSuccess) {
      final settlement = state.settlement;
      final items = settlement.items ?? [];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(items.length),

                  // Company list
                  _buildCompanyList(items),

                  SizedBox(height: 24.h),

                  // Total amount section
                  _buildTotalSection(settlement.totalSupplyAmount),

                  SizedBox(height: 120.h), // Space for bottom buttons
                ],
              ),
            ),
          ),

          // Bottom action buttons
          _buildBottomActions(settlement),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F1419),
      elevation: 0,
      scrolledUnderElevation: 0,
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
    );
  }

  Widget _buildHeader(int count) {
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
            '${count}건',
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(List<SettlementItem> items) {
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
          children: items
              .asMap()
              .entries
              .map((entry) => _buildCompanyItem(
            entry.value,
            isLast: entry.key == items.length - 1,
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCompanyItem(SettlementItem item, {bool isLast = false}) {
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
                      item.companyName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${item.mealCount}식',
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
                '${_formatCurrency(item.supplyAmount)}원',
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

  Widget _buildTotalSection(int totalAmount) {
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

  Widget _buildBottomActions(Settlement settlement) {
    final isConfirmed = settlement.status == 'CONFIRMED';

    return Container(
      padding: EdgeInsets.all(20.w),
      color: const Color(0xFF0F1419),
      child: Row(
        children: [
          // Copy text button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _copyText(settlement),
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
              onTap: isConfirmed ? null : () => _showConfirmDialog(settlement.id),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                decoration: BoxDecoration(
                  color: isConfirmed ? const Color(0xFF2D3748) : const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isConfirmed ? Icons.check_circle : Icons.check_circle_outline,
                      color: isConfirmed ? const Color(0xFF9CA3AF) : Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isConfirmed ? '확정됨' : '정산 확정',
                      style: TextStyle(
                        color: isConfirmed ? const Color(0xFF9CA3AF) : Colors.white,
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