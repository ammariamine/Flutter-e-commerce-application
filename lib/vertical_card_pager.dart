import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shopv2/screens/products.screen.dart';

typedef PageChangedCallback = void Function(double? page);
typedef PageSelectedCallback = void Function(int index);

enum ALIGN { LEFT, CENTER, RIGHT }

class VerticalCardPager extends StatefulWidget {
  final List<String> titles;
  final List<Widget> images;
  final PageChangedCallback? onPageChanged;
  final PageSelectedCallback? onSelectedItem;
  final ScrollPhysics? physics;
  final TextStyle? textStyle;
  final int initialPage;
  final ALIGN align;

  const VerticalCardPager({super.key, 
    required this.titles,
    required this.images,
    this.onPageChanged,
    this.textStyle,
    this.initialPage = 2,
    this.onSelectedItem,
    this.physics,
    this.align = ALIGN.CENTER,
  }) : assert(titles.length == images.length);

  @override
  _VerticalCardPagerState createState() => _VerticalCardPagerState();
}

class _VerticalCardPagerState extends State<VerticalCardPager> {
  late double currentPosition;
  late PageController controller;
  late bool isScrolling = false;

  get titles => widget.titles;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.initialPage.toDouble();
    controller = PageController(initialPage: widget.initialPage);
    controller.addListener(() {
      setState(() {
        currentPosition = controller.page ?? 0;
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(currentPosition);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onVerticalDragEnd: (_) => isScrolling = false,
        onVerticalDragStart: (_) => isScrolling = true,
        onTapUp: (details) {
          if ((currentPosition - currentPosition.floor()).abs() <= 0.15) {
            int selectedIndex = onTapUp(
              context,
              constraints.maxHeight,
              constraints.maxWidth,
              details,
            );
            if (selectedIndex == 2 && widget.onSelectedItem != null) {
              widget.onSelectedItem!(currentPosition.round());
            } else if (selectedIndex >= 0) {
              int goToPage = currentPosition.toInt() + selectedIndex - 2;
              controller.animateToPage(
                goToPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutExpo,
              );
              String title = titles[currentPosition.round()]; // Récupérer le titre de la catégorie sélectionnée
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Productscreen(title: title)), // Passer le titre de la catégorie à ProductScreen
              );
            }
          }
        },
        child: Stack(
          children: [
            CardControllerWidget(
              titles: widget.titles,
              images: widget.images,
              textStyle: widget.textStyle,
              currentPostion: currentPosition,
              cardViewPagerHeight: constraints.maxHeight,
              cardViewPagerWidth: constraints.maxWidth,
              align: widget.align,
            ),
            Positioned.fill(
              child: PageView.builder(
                physics: widget.physics,
                scrollDirection: Axis.vertical,
                itemCount: widget.images.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  int onTapUp(BuildContext context, double maxHeight, double maxWidth, TapUpDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    double dx = localOffset.dx;
    double dy = localOffset.dy;

    for (int i = 0; i < 5; i++) {
      double width = getWidth(maxHeight, i);
      double height = getHeight(maxHeight, i);
      double? left = getStartPositon(maxWidth, width);
      double top = getCardPositionTop(height, maxHeight, i);

      if (top <= dy && dy <= top + height) {
        if (left <= dx && dx <= left + width) {
          return i;
        }
      }
    }
    return -1;
  }

  double getStartPositon(double cardViewPagerWidth, double cardWidth) {
    switch (widget.align) {
      case ALIGN.LEFT:
        return 0;
      case ALIGN.CENTER:
        return (cardViewPagerWidth / 2) - (cardWidth / 2);
      case ALIGN.RIGHT:
        return cardViewPagerWidth - cardWidth;
    }
  }

  double getWidth(double maxHeight, int i) {
    double cardMaxWidth = maxHeight / 2;
    return cardMaxWidth - 60 * (i - 2).abs();
  }

  double getHeight(double maxHeight, int i) {
    double cardMaxHeight = maxHeight / 2;
    if (i == 2) {
      return cardMaxHeight;
    } else if (i == 0 || i == 4) {
      return cardMaxHeight - cardMaxHeight * (4 / 5) - 10;
    } else {
      return cardMaxHeight - cardMaxHeight * (4 / 5);
    }
  }
}

double getCardPositionTop(double cardHeight, double viewHeight, int i) {
  int diff = (2 - i);
  int diffAbs = diff.abs();
  double basePosition = (viewHeight / 2) - (cardHeight / 2);
  double cardMaxHeight = viewHeight / 2;
  if (diffAbs == 0) {
    return basePosition;
  }
  if (diffAbs == 1) {
    return diff >= 0 ? basePosition - (cardMaxHeight * (6 / 9)) : basePosition + (cardMaxHeight * (6 / 9));
  } else {
    return diff >= 0 ? basePosition - cardMaxHeight * (8 / 9) : basePosition + cardMaxHeight * (8 / 9);
  }
}

class CardControllerWidget extends StatelessWidget {
  final double? currentPostion;
  final double cardMaxWidth;
  final double cardMaxHeight;
  final double cardViewPagerHeight;
  final double? cardViewPagerWidth;
  final TextStyle? textStyle;
  final ALIGN align;

  final List? titles;
  final List? images;

  const CardControllerWidget({super.key, 
    this.titles,
    this.images,
    this.cardViewPagerWidth,
    required this.cardViewPagerHeight,
    this.currentPostion,
    required this.align,
    this.textStyle,
  }) : cardMaxHeight = cardViewPagerHeight * (1 / 2),
        cardMaxWidth = cardViewPagerHeight * (1 / 2);

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];

    var titleTextStyle = textStyle ?? Theme.of(context).textTheme.titleLarge;

    for (int i = 0; i < images!.length; i++) {
      var cardWidth = max(cardMaxWidth - 60 * (currentPostion! - i).abs(), 0.0);
      var cardHeight = getCardHeight(i);
      var cardTop = getTop(cardHeight, cardViewPagerHeight, i);

      Widget card = Positioned.directional(
        textDirection: TextDirection.ltr,
        top: cardTop,
        start: getStartPositon(cardWidth),
        child: Opacity(
          opacity: getOpacity(i),
          child: Material( // Utilisez Material pour envelopper votre Stack
            color: Colors.transparent, // Couleur transparente pour que l'encre fonctionne correctement
            child: InkWell( // Utilisez InkWell pour détecter les clics
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Productscreen()), // Remplacez ProductScreen par votre widget d'écran de produit réel
                );
              },*/
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Stack(
                  children: <Widget>[
                    ClipRRect( // ClipRRect pour arrondir les coins de l'image
                      borderRadius: BorderRadius.circular(16.0), // Vous pouvez ajuster le rayon de la bordure selon votre préférence
                      child: images![i],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Text(
                          titles![i],
                          style: titleTextStyle?.copyWith(fontSize: getFontSize(i),fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],

                ),
              ),

            ),
          ),
        ),
      );

      cardList.add(card);

    }

    return Stack(
      children: cardList,
    );
  }

  double getOpacity(int i) {
    double diff = (currentPostion! - i);

    if (diff >= -2 && diff <= 2) {
      return 1.0;
    } else if (diff > -3 && diff < -2) {
      return 3 - diff.abs();
    } else if (diff > 2 && diff < 3) {
      return 3 - diff.abs();
    } else {
      return 0;
    }
  }

  double getTop(double cardHeight, double viewHeight, int i) {
    double diff = (currentPostion! - i);
    double diffAbs = diff.abs();
    double basePosition = (viewHeight / 2) - (cardHeight / 2);

    if (diffAbs == 0) {
      return basePosition;
    }
    if (diffAbs > 0.0 && diffAbs <= 1.0) {
      return diff >= 0 ? basePosition - (cardMaxHeight * (6 / 9)) * diffAbs : basePosition + (cardMaxHeight * (6 / 9)) * diffAbs;
    } else if (diffAbs > 1.0 && diffAbs < 2.0) {
      return diff >= 0
          ? basePosition - (cardMaxHeight * (6 / 9)) - cardMaxHeight * (2 / 9) * (diffAbs - diffAbs.floor()).abs()
          : basePosition + (cardMaxHeight * (6 / 9)) + cardMaxHeight * (2 / 9) * (diffAbs - diffAbs.floor()).abs();
    } else {
      return diff >= 0 ? basePosition - cardMaxHeight * (8 / 9) : basePosition + cardMaxHeight * (8 / 9);
    }
  }

  double getCardHeight(int index) {
    double diff = (currentPostion! - index).abs();

    if (diff >= 0.0 && diff < 1.0) {
      return cardMaxHeight - cardMaxHeight * (4 / 5) * ((diff - diff.floor()));
    } else if (diff >= 1.0 && diff < 2.0) {
      return cardMaxHeight - cardMaxHeight * (4 / 5) - 10 * ((diff - diff.floor()));
    } else {
      final height = cardMaxHeight - cardMaxHeight * (4 / 5) - 10 - 5 * ((diff - diff.floor()));
      return height > 0 ? height : 0;
    }
  }

  double getFontSize(int index) {
    double diffAbs = (currentPostion! - index).abs();
    diffAbs = num.parse(diffAbs.toStringAsFixed(2)) as double;

    double maxFontSize = 24;
    if (diffAbs >= 0.0 && diffAbs < 1.0) {
      if (diffAbs < 0.02) {
        diffAbs = 0;
      }
      return maxFontSize - 12 * ((diffAbs - diffAbs.floor()));
    } else if (diffAbs >= 1.0 && diffAbs < 2.0) {
      return maxFontSize - 12 - 3 * ((diffAbs - diffAbs.floor()));
    } else {
      final fontSize = maxFontSize - 14 - 6 * ((diffAbs - diffAbs.floor()));
      return fontSize > 0 ? fontSize : 0;
    }
  }

  double getStartPositon(double cardWidth) {
    switch (align) {
      case ALIGN.LEFT:
        return 0;
      case ALIGN.CENTER:
        return (cardViewPagerWidth! / 2) - (cardWidth / 2);
      case ALIGN.RIGHT:
        return cardViewPagerWidth! - cardWidth;
    }
  }
}
