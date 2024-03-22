import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';


class OnHover extends StatefulWidget {
  final Widget child;
  final bool isItem;
  final bool fromMenu;
  const OnHover({Key? key, required this.child, this.isItem = false, this.fromMenu = false}) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hoverTransformed = Matrix4.identity()..scale(1.05, 1.03);
    final transform = isHovered ? hoverTransformed : Matrix4.identity();
    final shadow1 = BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      color: widget.fromMenu ? Theme.of(context).primaryColor.withOpacity(0.10) : Theme.of(context).cardColor,
      boxShadow: [
        widget.fromMenu ? const BoxShadow(color: Colors.transparent) :
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 0),
        ),
      ],
    );
    final shadow2 = BoxDecoration(
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      boxShadow: const [
        BoxShadow(
          color: Colors.transparent,
          blurRadius: 0,
          offset: Offset(0, 0),
        )
      ],
    );
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: widget.isItem ? isHovered ? shadow1 : shadow2 : shadow2,
        transform: widget.isItem ? Matrix4.identity() : transform  ,
        child: widget.child,
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
