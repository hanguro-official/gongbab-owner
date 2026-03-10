import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettlementRegisterScreen extends StatefulWidget {
  const SettlementRegisterScreen({super.key});

  @override
  State<SettlementRegisterScreen> createState() =>
      _SettlementRegisterScreenState();
}

class _SettlementRegisterScreenState extends State<SettlementRegisterScreen> {
  DateTime selectedMonth = DateTime.now();
  bool applyUniformPrice = false;
  final TextEditingController uniformPriceController = TextEditingController();

  List<SettlementRow> rows = [
    SettlementRow(), // Initial empty row
  ];

  @override
  void dispose() {
    uniformPriceController.dispose();
    for (var row in rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      rows.add(SettlementRow());
    });
  }

  void _removeRow(int index) {
    if (rows.length > 1) {
      setState(() {
        rows[index].dispose();
        rows.removeAt(index);
      });
    }
  }

  void _onUniformPriceChanged() {
    setState(() {
      applyUniformPrice = !applyUniformPrice;
      if (applyUniformPrice && uniformPriceController.text.isNotEmpty) {
        final price = int.tryParse(uniformPriceController.text) ?? 0;
        for (var row in rows) {
          row.unitPriceController.text = price.toString();
          row.calculateTotal();
        }
      }
    });
  }

  void _onUniformPriceValueChanged(String value) {
    if (applyUniformPrice) {
      final price = int.tryParse(value) ?? 0;
      for (var row in rows) {
        row.unitPriceController.text = price.toString();
        row.calculateTotal();
      }
      setState(() {});
    }
  }

  int get totalAmount {
    return rows.fold(0, (sum, row) => sum + row.totalAmount);
  }

  void _saveSettlement() {
    // Validate
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
        SnackBar(
          content: Text('최소 하나의 정산 내역을 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Save settlement data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('정산이 저장되었습니다.'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _selectMonth() {
    // TODO: Show month picker
  }

  String _formatMonth(DateTime date) {
    return '${date.year}년 ${date.month}월';
  }

  List<DateTime> _getMonths() {
    final now = DateTime.now();
    return List.generate(5, (i) => DateTime(now.year, now.month - 3 + i, 1));
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
                  // Month selector section
                  _buildMonthSelector(),

                  // Uniform price checkbox
                  _buildUniformPriceSection(),

                  // Table rows
                  _buildTableRows(),

                  // Add row button
                  _buildAddRowButton(),

                  SizedBox(height: 120.h), // Space for bottom section
                ],
              ),
            ),
          ),

          // Total and save button
          _buildBottomSection(),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: months.map((month) {
                final isSelected = selectedMonth.year == month.year &&
                    selectedMonth.month == month.month;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _buildMonthButton(month, isSelected),
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
        setState(() {
          selectedMonth = month;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUniformPriceSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
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
                onTap: _onUniformPriceChanged,
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
                          color: Colors.white,
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
                enabled: applyUniformPrice,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onUniformPriceValueChanged,
                style: TextStyle(
                  color: Colors.white,
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
            // Company name and delete button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: row.companyController,
                    style: TextStyle(
                      color: Colors.white,
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
                if (rows.length > 1)
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

            // Unit price
            TextField(
              controller: row.unitPriceController,
              enabled: !applyUniformPrice,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  row.calculateTotal();
                });
              },
              style: TextStyle(
                color: const Color(0xFF3B82F6),
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
                  color: const Color(0xFF3B82F6),
                  fontSize: 14.sp,
                ),
              ),
            ),

            SizedBox(height: 16.h),
            Container(height: 1.h, color: const Color(0xFF2D3748)),
            SizedBox(height: 16.h),

            // Quantity and total
            Row(
              children: [
                // Quantity controls
                Flexible(
                  flex: 5,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
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
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: row.quantityController,
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
                            color: Colors.white,
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
                        onTap: () {
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
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),

                // Total amount
                Flexible(
                  flex: 4,
                  child: Text(
                    '${_formatCurrency(row.totalAmount)}원',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
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
          // Total
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
                    color: const Color(0xFF3B82F6),
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

          // Save button
          GestureDetector(
            onTap: _saveSettlement,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '저장하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
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
    final unitPrice = int.tryParse(unitPriceController.text) ?? 0;
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