import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_wow/components/widgets/custon_icon_button.dart';

class DoubleTappableInteractiveViewer extends StatefulWidget {
  final double scale;
  final Duration scaleDuration;
  final Curve curve;
  final Widget child;

  const DoubleTappableInteractiveViewer({
    Key? key,
    this.scale = 2,
    this.curve = Curves.fastLinearToSlowEaseIn,
    required this.scaleDuration,
    required this.child,
  });

  @override
  State<DoubleTappableInteractiveViewer> createState() => _DoubleTappableInteractiveViewerState();
}

class _DoubleTappableInteractiveViewerState extends State<DoubleTappableInteractiveViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  late TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    )..addListener(() {
        _transformationController.value = _zoomAnimation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final newValue = _transformationController.value.isIdentity() ? _applyZoom() : _revertZoom();

    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: newValue,
    ).animate(CurveTween(curve: widget.curve).animate(_animationController));
    _animationController.forward(from: 0);
  }

  Matrix4 _applyZoom() {
    final tapPosition = _doubleTapDetails!.localPosition;
    final translationCorrection = widget.scale - 1;
    final zoomed = Matrix4.identity()
      ..translate(
        -tapPosition.dx * translationCorrection,
        -tapPosition.dy * translationCorrection,
      )
      ..scale(widget.scale);
    return zoomed;
  }

  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Container(
                height: screenSize.height,
                width: screenSize.width,
                child: GestureDetector(
                  onDoubleTapDown: _handleDoubleTapDown,
                  onDoubleTap: _handleDoubleTap,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 3,
                    transformationController: _transformationController,
                    child: widget.child,
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14),
                  child: CustomIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 4,
                    buttonSize: 40,
                    borderWidth: 1,
                    icon: SvgPicture.asset(
                      'assets/images/arrow_left.svg',
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
