import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderInput extends StatelessWidget {
  final bool _isPassword;
  final String _initialValue;
  final String _text;
  final int? _maxLength;
  final Function(String)? _onChange;
  final bool _autoFocus;
  final TextEditingController? _textEditingController;
  final TextInputType? _keyboardType;
  final FocusNode? _focusNode;
  final VoidCallback? _onEditingComplete;
  final String? Function(String?)? _validator;
  final String _filterPattern;

  const BorderInput({
    Key? key,
    bool isPassword = false,
    bool autoFocus = false,
    String initialValue = '',
    String filterPattern = '[]',
    TextInputType? keyboardType,
    required String text,
    Function(String)? onChange,
    FocusNode? focusNode,
    VoidCallback? onEditingComplete,
    TextEditingController? textEditingController,
    String? Function(String?)? validator,
    int? maxLength,
  })  : _isPassword = isPassword,
        _initialValue = initialValue,
        _validator = validator,
        _onChange = onChange,
        _maxLength = maxLength,
        _text = text,
        _autoFocus = autoFocus,
        _keyboardType = keyboardType,
        _focusNode = focusNode,
        _onEditingComplete = onEditingComplete,
        _filterPattern = filterPattern,
        _textEditingController = textEditingController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: _textEditingController,
      keyboardType: _keyboardType,
      initialValue: _textEditingController == null ? _initialValue : null,
      autocorrect: false,
      autofocus: _autoFocus,
      onChanged: _onChange,
      validator: _validator,
      maxLength: _maxLength,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(color: Colors.black87, fontSize: 32.sp),
      obscureText: _isPassword,
      inputFormatters: [
        LengthLimitingTextInputFormatter(_maxLength),
        FilteringTextInputFormatter.deny(RegExp(_filterPattern))
      ],
      textInputAction: TextInputAction.next,
      onEditingComplete: _onEditingComplete,
      decoration: InputDecoration(
        isDense: true,
        hintText: _text,
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.0.h,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0.h),
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20),
        errorStyle: TextStyle(fontSize: 26.sp, height: 1.h),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
