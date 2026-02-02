import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Input mode: true for number keypad, false for alphabet keypad
  bool isNumberMode = true;

  // Store the 5 input values (4 numbers + 1 letter)
  List<String?> inputs = [null, null, null, null, null];
  int currentIndex = 0;

  // TextEditingControllers for each input field
  final List<TextEditingController> _controllers = List.generate(
    5,
        (index) => TextEditingController(),
  );

  // FocusNodes for each input field
  final List<FocusNode> _focusNodes = List.generate(
    5,
        (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    // Auto-focus first field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (currentIndex < 4) {
      setState(() {
        inputs[currentIndex] = number;
        _controllers[currentIndex].text = number;
        currentIndex++;
        // Switch to alphabet mode after 4 digits
        if (currentIndex == 4) {
          isNumberMode = false;
          _focusNodes[4].requestFocus();
        } else {
          _focusNodes[currentIndex].requestFocus();
        }
      });
    }
  }

  void _onLetterPressed(String letter) {
    if (currentIndex == 4) {
      setState(() {
        inputs[currentIndex] = letter;
        _controllers[currentIndex].text = letter;
        currentIndex++;
        _focusNodes[4].unfocus();
      });
    }
  }

  void _onBackspace() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        inputs[currentIndex] = null;
        _controllers[currentIndex].clear();
        _focusNodes[currentIndex].requestFocus();
        // Switch back to number mode if clearing from alphabet
        if (currentIndex < 4) {
          isNumberMode = true;
        }
      }
    });
  }

  void _onClearAll() {
    setState(() {
      inputs = [null, null, null, null, null];
      for (var controller in _controllers) {
        controller.clear();
      }
      currentIndex = 0;
      isNumberMode = true;
      _focusNodes[0].requestFocus();
    });
  }

  void _onLogin() {
    if (currentIndex == 5) {
      // All inputs filled, proceed with login
      String pin = inputs.sublist(0, 4).join();
      String alphabet = inputs[4]!;

      // Unfocus all fields to hide keyboard
      for (var focusNode in _focusNodes) {
        focusNode.unfocus();
      }

      // TODO: Implement login logic
      print('PIN: $pin, Alphabet: $alphabet');

      // Navigate to next screen or show error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위젯들을 위, 아래, 중간에 배치
            children: [
              // 상단 공간 (SizedBox 또는 다른 위젯으로 조절)
              SizedBox(height: 40.h),
              Column(
                children: [
                  // Title
                  Text(
                    '관리자 로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Subtitle
                  Text(
                    '번호 4자리 + 알파벳 1자리',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              // Input dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: _buildInputDot(index),
                  ),
                ),
              ),
              // 하단 공간
              Column(
                children: [
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: currentIndex == 5 ? _onLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        disabledBackgroundColor: const Color(0xFF1E293B),
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: currentIndex == 5
                              ? Colors.white
                              : const Color(0xFF64748B),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 20.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputDot(int index) {
    bool isFilled = inputs[index] != null && inputs[index]!.isNotEmpty;
    bool isActive = currentIndex == index;
    bool isAlphabet = index == 4;

    return SizedBox(
      width: 64.w,
      height: 64.h,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: isAlphabet ? TextInputType.text : TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        obscureText: isFilled,
        obscuringCharacter: '●',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          if (isAlphabet)
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]'))
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFF1A2332),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: const Color(0xFF2D3748),
              width: 2.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: const Color(0xFF3B82F6),
              width: 2.w,
            ),
          ),
          hintText: isAlphabet && !isFilled ? 'A' : '',
          hintStyle: TextStyle(
            color: const Color(0xFF3B82F6),
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          isDense: true,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              if (isAlphabet) {
                // Alphabet field - only accept letters
                inputs[index] = value.toUpperCase();
                _controllers[index].text = value.toUpperCase();
                _controllers[index].selection = TextSelection.fromPosition(
                  TextPosition(offset: _controllers[index].text.length),
                );
                currentIndex = 5;
                // Unfocus after entering alphabet
                _focusNodes[index].unfocus();
              } else {
                // Number field - only accept digits
                inputs[index] = value;
                currentIndex = index + 1;
                // Move to next field
                if (index < 4) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              }
            });
          } else {
            // Handle backspace
            setState(() {
              inputs[index] = null;
              if (index > 0) {
                currentIndex = index;
              }
            });
          }
        },
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}