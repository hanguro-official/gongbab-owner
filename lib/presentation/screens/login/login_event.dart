import 'package:flutter/material.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String code;

  LoginButtonPressed({required this.code});
}

class ShowSnackBar extends LoginEvent {
  final String message;
  final Color backgroundColor;

  ShowSnackBar({required this.message, this.backgroundColor = Colors.black});
}

class ShowAlertDialog extends LoginEvent {
  final String title;
  final String? content;
  final String? leftButtonText;
  final VoidCallback? onLeftButtonPressed;
  final String rightButtonText;
  final VoidCallback onRightButtonPressed;

  ShowAlertDialog({
    required this.title,
    this.content,
    this.leftButtonText,
    this.onLeftButtonPressed,
    required this.rightButtonText,
    required this.onRightButtonPressed,
  });
}
