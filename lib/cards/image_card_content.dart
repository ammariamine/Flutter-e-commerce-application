import 'package:flutter/material.dart';

class ImageCardContent extends StatelessWidget {
  const  ImageCardContent({
    super.key,
    this.contentPadding,
    this.tags,
    this.title,
    this.price,
    this.footer,
    this.tagSpacing,
    this.tagRunSpacing,
  });

  final EdgeInsetsGeometry? contentPadding;
  final List<Widget>? tags;
  final double? tagSpacing;
  final double? tagRunSpacing;

  final Widget? title;
  final Widget? price;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: contentPadding ??
          const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tags != null)
            Wrap(
              spacing: tagSpacing ?? 12,
              runSpacing: tagRunSpacing ?? 10,
              children: tags!,
            ),
          if (title != null || price != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) title!,
                  if (title != null && price != null)
                    const SizedBox(
                      height: 2,
                    ),
                  if (price != null) price!,
                ],
              ),
            ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: footer!,
            ),
        ],
      ),
    );
  }
}
