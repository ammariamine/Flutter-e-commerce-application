import 'package:flutter/material.dart';

import 'image_card_content.dart';

class TransparentImageCard extends StatelessWidget {
  const TransparentImageCard({
    super.key,
    this.width,
    this.height,
    this.contentMarginTop,
    this.borderRadius = 6,
    this.contentPadding,
    required this.imageProvider,
    this.tags,
    this.title,
    this.price,
    this.footer,
    this.startColor,
    this.endColor,
    this.tagSpacing,
    this.tagRunSpacing,
  });

  final double? width;
  final double? height;
  final double? contentMarginTop;
  final double borderRadius;
  final double? tagSpacing;
  final double? tagRunSpacing;
  final EdgeInsetsGeometry? contentPadding;
  final ImageProvider imageProvider;
  final List<Widget>? tags;
  final Color? startColor;
  final Color? endColor;
  final Widget? title;
  final Widget? price;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final Widget content = SingleChildScrollView(
      child: ImageCardContent(
        contentPadding: contentPadding,
        tags: tags,
        title: title,
        footer: footer,
        price: price,
        tagSpacing: tagSpacing,
        tagRunSpacing: tagRunSpacing,
      ),
    );

    return _buildBody(content);
  }

  Widget _buildBody(Widget content) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: ShaderMask(
            shaderCallback: (bound) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  startColor ?? const Color(0xff575757).withOpacity(0),
                  endColor ?? const Color(0xff000000),
                ],
              ).createShader(bound);
            },
            blendMode: BlendMode.srcOver,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.only(top: contentMarginTop ?? 100),
              child: content,
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.only(top: contentMarginTop ?? 100),
            child: content,
          ),
        ),
      ],
    );
  }
}
