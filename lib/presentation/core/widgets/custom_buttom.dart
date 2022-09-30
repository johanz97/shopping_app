import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtom extends StatefulWidget {
  final VoidCallback onTap;
  final bool hasGradient;
  final Color color;
  final String title;
  final bool isActive;
  final double width;
  final double? height;
  final IconData? icon;

  const CustomButtom({
    Key? key,
    required this.onTap,
    required this.title,
    required this.width,
    this.icon,
    this.isActive = false,
    this.color = Colors.white,
    this.hasGradient = true,
    this.height,
  }) : super(key: key);

  @override
  State<CustomButtom> createState() => _CustomButtomState();
}

class _CustomButtomState extends State<CustomButtom> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: widget.height ?? 100.h,
          margin: EdgeInsets.symmetric(vertical: 20.h),
          constraints: BoxConstraints(
            maxHeight: 90.h,
            minHeight: 70.h,
            maxWidth: widget.width.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: widget.hasGradient && widget.isActive
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).primaryColor
                    ],
                  )
                : null,
            color: widget.isActive ? Colors.white : Colors.grey,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, isPressed ? 0 : 4.0),
                blurRadius: 2.0,
                spreadRadius: 2.0,
                color: const Color.fromRGBO(196, 196, 196, .76),
              )
            ],
          ),
          child: InkWell(
            onHighlightChanged: (hover) {
              setState(() {
                isPressed = hover;
              });
            },
            borderRadius: BorderRadius.circular(20),
            onTap: widget.isActive ? widget.onTap : null,
            child: Center(
              child: Row(
                mainAxisAlignment: widget.icon != null
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        widget.icon,
                        color:
                            !widget.hasGradient ? Colors.black : Colors.white,
                      ),
                    ),
                  if (widget.title.isNotEmpty)
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 35.sp,
                            color: widget.isActive
                                ? widget.hasGradient
                                    ? Colors.white
                                    : Colors.black
                                : Colors.black,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
