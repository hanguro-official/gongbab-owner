import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab_owner/domain/entities/settlement/settlement.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_ui_state.dart';
import 'package:gongbab_owner/presentation/screens/settlement_register/settlement_register_view_model.dart';
import 'package:gongbab_owner/presentation/widgets/custom_alert_dialog.dart';
import 'package:intl/intl.dart';

class SettlementRegisterScreen extends StatefulWidget {
  const SettlementRegisterScreen({super.key});

  @override
  State<SettlementRegisterScreen> createState() =>
      _SettlementRegisterScreenState();
}

class _SettlementRegisterScreenState extends State<SettlementRegisterScreen> {
  late SettlementRegisterViewModel _viewModel;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  bool applyUniformPrice = false;
  final TextEditingController uniformPriceController = TextEditingController();
  String? _currentStatus;

  List<SettlementRow> rows = [
    SettlementRow(), // Initial empty row
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.instance<SettlementRegisterViewModel>();
    _viewModel.addListener(_onViewModelChange);
    _loadSettlement();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    uniformPriceController.dispose();
    for (var row in rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _onViewModelChange() {
    final state = _viewModel.uiState;
    if (state is SettlementRegisterSuccess) {
      setState(() {
        _currentStatus = state.settlement?.status;
      });
      _populateFromSettlement(state.settlement);
    } else if (state is SettlementSaveSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정산 내역이 저장되었습니다.')),
      );
      context.pop();
    } else if (state is SettlementRegisterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  bool get _isConfirmed => _currentStatus == 'CONFIRMED';

  void _loadSettlement() {
    _viewModel.onEvent(LoadSettlementForMonth(
      year: selectedMonth.year,
      month: selectedMonth.month,
    ));
  }

  void _populateFromSettlement(Settlement? settlement) {
    setState(() {
      rows.clear();
      if (settlement != null && settlement.items != null && settlement.items!.isNotEmpty) {
        for (var item in settlement.items!) {
          final row = SettlementRow();
          row.companyController.text = item.companyName;
          row.unitPriceController.text = NumberFormat('#,###').format(item.unitPrice);
          row.quantityController.text = item.mealCount.toString();
          row.calculateTotal();
          rows.add(row);
        }
      } else {
        rows.add(SettlementRow());
      }
    });
  }

  void _addRow() {
    if (_isConfirmed) return;
    setState(() {
      rows.add(SettlementRow());
    });
  }

  void _removeRow(int index) {
    if (_isConfirmed) return;
    if (rows.length > 1) {
      setState(() {
        rows[index].dispose();
        rows.removeAt(index);
      });
    }
  }

  void _onUniformPriceChanged() {
    if (_isConfirmed) return;
    setState(() {
      applyUniformPrice = !applyUniformPrice;
      if (applyUniformPrice && uniformPriceController.text.isNotEmpty) {
        final priceString = uniformPriceController.text.replaceAll(',', '');
        final price = int.tryParse(priceString) ?? 0;
        final formattedPrice = NumberFormat('#,###').format(price);
        for (var row in rows) {
          row.unitPriceController.text = formattedPrice;
          row.calculateTotal();
        }
      }
    });
  }

  void _onUniformPriceValueChanged(String value) {
    if (_isConfirmed) return;
    if (applyUniformPrice) {
      final priceString = value.replaceAll(',', '');
      final price = int.tryParse(priceString) ?? 0;
      final formattedPrice = NumberFormat('#,###').format(price);
      for (var row in rows) {
        row.unitPriceController.text = formattedPrice;
        row.calculateTotal();
      }
      setState(() {});
    }
  }

  int get totalAmount {
    return rows.fold(0, (sum, row) => sum + row.totalAmount);
  }

  void _onSaveButtonPressed() {
    if (_isConfirmed) return;
    bool hasData = false;
    for (var row in rows) {
      if (row.companyController.text.isNotEmpty ||
          row.quantityController.text.isNotEmpty ||
          row.unitPriceController.text.isNotEmpty) {
        hasData = true;
        break;
      }
    }

    if (!hasData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 하나의 정산 내역을 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: '정산 내역을 저장하시겠어요?',
        content: '정산 확정하기 전까지 수정할 수 있어요',
        leftButtonText: '취소',
        onLeftButtonPressed: () {},
        rightButtonText: '저장하기',
        onRightButtonPressed: _saveSettlement,
      ),
    );
  }

  void _saveSettlement() {
    final List<Map<String, dynamic>> items = rows.where((row) => row.companyController.text.isNotEmpty).map((row) {
      final priceString = row.unitPriceController.text.replaceAll(',', '');
      return {
        'companyName': row.companyController.text,
        'unitPrice': int.tryParse(priceString) ?? 0,
        'mealCount': int.tryParse(row.quantityController.text) ?? 0,
      };
    }).toList();

    _viewModel.onEvent(SaveSettlement(
      year: selectedMonth.year,
      month: selectedMonth.month,
      items: items,
    ));
  }

  String _formatMonth(DateTime date) {
    return '${date.year}년 ${date.month}월';
  }

  List<DateTime> _getMonths() {
    final now = DateTime.now();
    return List.generate(3, (i) => DateTime(now.year, now.month - 1 + i, 1));
  }

  String _formatCurrency(int amount) {
    return NumberFormat('#,###').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMonthSelector(),
                      _buildUniformPriceSection(),

                      if (_viewModel.uiState is SettlementRegisterLoading)
                        SizedBox(
                          height: 200.h,
                          child: const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
                        )
                      else ...[
                        _buildTableRows(),
                        _buildAddRowButton(),
                      ],

                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
              ),
              _buildBottomSection(),
            ],
          );
        },
      ),
    );
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
        '정산 입력',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMonthSelector() {
    final months = _getMonths();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              '대상 월',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: months.map((month) {
                final isSelected = selectedMonth.year == month.year &&
                    selectedMonth.month == month.month;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: _buildMonthButton(month, isSelected),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthButton(DateTime month, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (selectedMonth.year != month.year || selectedMonth.month != month.month) {
          setState(() {
            selectedMonth = month;
          });
          _loadSettlement();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: Text(
          _formatMonth(month),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUniformPriceSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: _isConfirmed ? null : _onUniformPriceChanged,
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: applyUniformPrice
                            ? const Color(0xFF3B82F6)
                            : Colors.transparent,
                        border: Border.all(
                          color: applyUniformPrice
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF6B7280),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: applyUniformPrice
                          ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14.sp,
                      )
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        '단가 동일 적용',
                        style: TextStyle(
                          color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                          fontSize: 14.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              flex: 2,
              child: TextField(
                controller: uniformPriceController,
                enabled: applyUniformPrice && !_isConfirmed,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                onChanged: _onUniformPriceValueChanged,
                style: TextStyle(
                  color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: '단가',
                  hintStyle: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0F1419),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: const Color(0xFF2D3748),
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: const Color(0xFF2D3748),
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: const Color(0xFF3B82F6),
                      width: 1.w,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 10.h,
                  ),
                  suffixText: '원',
                  suffixStyle: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRows() {
    return Column(
      children: rows
          .asMap()
          .entries
          .map((entry) => _buildTableRow(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildTableRow(int index, SettlementRow row) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF2D3748),
            width: 1.5.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: row.companyController,
                    enabled: !_isConfirmed,
                    style: TextStyle(
                      color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '업체명',
                      hintStyle: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (rows.length > 1 && !_isConfirmed)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: const Color(0xFF6B7280),
                      size: 20.sp,
                    ),
                    onPressed: () => _removeRow(index),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: row.unitPriceController,
              enabled: !applyUniformPrice && !_isConfirmed,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              onChanged: (value) {
                setState(() {
                  row.calculateTotal();
                });
              },
              style: TextStyle(
                color: _isConfirmed ? const Color(0xFF6B7280) : const Color(0xFF3B82F6),
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: '단가',
                hintStyle: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                suffixText: '원',
                suffixStyle: TextStyle(
                  color: _isConfirmed ? const Color(0xFF6B7280) : const Color(0xFF3B82F6),
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(height: 1.h, color: const Color(0xFF2D3748)),
            SizedBox(height: 16.h),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _isConfirmed ? null : () {
                          setState(() {
                            row.decrementQuantity();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: row.quantityController,
                          enabled: !_isConfirmed,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              row.calculateTotal();
                            });
                          },
                          style: TextStyle(
                            color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: _isConfirmed ? null : () {
                          setState(() {
                            row.incrementQuantity();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.add,
                            color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  flex: 4,
                  child: Text(
                    '${_formatCurrency(row.totalAmount)}원',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: _isConfirmed ? const Color(0xFF6B7280) : Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRowButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: GestureDetector(
        onTap: _addRow,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF2D3748),
              width: 1.5.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '행 추가',
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

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: const Color(0xFF0F1419),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '총 합계',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  '${_formatCurrency(totalAmount)}원',
                  style: TextStyle(
                    color: _isConfirmed ? const Color(0xFF6B7280) : const Color(0xFF3B82F6),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _isConfirmed ? null : _onSaveButtonPressed,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: _isConfirmed ? const Color(0xFF2D3748) : const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _isConfirmed ? '이미 확정된 정산입니다' : '저장하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isConfirmed ? const Color(0xFF9CA3AF) : Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettlementRow {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController quantityController =
  TextEditingController(text: '0');

  int totalAmount = 0;

  void calculateTotal() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final unitPriceString = unitPriceController.text.replaceAll(',', '');
    final unitPrice = int.tryParse(unitPriceString) ?? 0;
    totalAmount = quantity * unitPrice;
  }

  void incrementQuantity() {
    final currentValue = int.tryParse(quantityController.text) ?? 0;
    quantityController.text = (currentValue + 1).toString();
    calculateTotal();
  }

  void decrementQuantity() {
    final currentValue = int.tryParse(quantityController.text) ?? 0;
    if (currentValue > 0) {
      quantityController.text = (currentValue - 1).toString();
      calculateTotal();
    }
  }

  void dispose() {
    companyController.dispose();
    unitPriceController.dispose();
    quantityController.dispose();
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int? value = int.tryParse(newValue.text.replaceAll(',', ''));
    if (value == null) {
      return oldValue;
    }

    final String formattedValue = NumberFormat('#,###').format(value);

    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
