import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.fillColor,
    this.disabledColor,
    this.onPressed,
    this.showLoadingIndicator = false,
  }) : super(key: key);

  final Widget icon;
  final double? borderRadius;
  final double? buttonSize;
  final Color? fillColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double? borderWidth;
  final bool showLoadingIndicator;
  final Function()? onPressed;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool loading = false;
  late double? iconSize;
  late Color? iconColor;

  @override
  void initState() {
    final isNotIcon = widget.icon is Icon;
    if (isNotIcon) {
      final icon = widget.icon as Icon;
      iconSize = icon.size;
      iconColor = icon.color;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: widget.borderRadius != null ? BorderRadius.circular(widget.borderRadius!) : null,
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: widget.buttonSize,
        height: widget.buttonSize,
        decoration: BoxDecoration(
          color: widget.onPressed != null ? widget.fillColor : widget.disabledColor,
          border: Border.all(
            color: widget.borderColor ?? Colors.transparent,
            width: widget.borderWidth ?? 0,
          ),
          borderRadius: widget.borderRadius != null ? BorderRadius.circular(widget.borderRadius!) : null,
        ),
        child: (widget.showLoadingIndicator && loading)
            ? Center(
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      iconColor ?? Colors.white,
                    ),
                  ),
                ),
              )
            : IconButton(
                icon: widget.icon,
                onPressed: widget.onPressed == null
                    ? null
                    : () async {
                        if (loading) {
                          return;
                        }
                        setState(() => loading = true);
                        try {
                          await widget.onPressed!();
                        } finally {
                          if (mounted) {
                            setState(() => loading = false);
                          }
                        }
                      },
                splashRadius: widget.borderRadius,
              ),
      ),
    );
  }
}

Padding emptyButton() {
  return Padding(
    padding: const EdgeInsets.only(left: 4),
    child: CustomIconButton(
        borderColor: Colors.transparent,
        borderRadius: 4,
        buttonSize: 45,
        borderWidth: 1,
        icon: Container(),
        onPressed: null),
  );
}
