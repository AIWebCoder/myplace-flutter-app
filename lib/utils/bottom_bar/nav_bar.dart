import 'dart:ui';

// import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
// import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

class CrystalNavigationBarDesign extends StatelessWidget {
  const CrystalNavigationBarDesign({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.height = 105,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
    this.indicatorColor,
    this.marginR = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    this.paddingR = const EdgeInsets.only(bottom: 5, top: 10),
    this.borderRadius = 30,
    this.splashBorderRadius,
    this.backgroundColor = Colors.transparent,
    this.outlineBorderColor = Colors.white24,
    this.borderWidth = 0.0,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.transparent,
        spreadRadius: 0,
        blurRadius: 0,
        offset: Offset(0, 0), // changes position of shadow
      ),
    ],
    this.enableFloatingNavBar = true,
    this.enablePaddingAnimation = true,
    this.splashColor,
  });

  /// A list of tabs to display, ie `Home`, `Profile`,`Cart`, etc
  final List<CrystalNavigationBarItem2> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The color of the icon and text when the item is selected.
  final Color? selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color? unselectedItemColor;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  /// The color of the bottom indicator.
  final Color? indicatorColor;

  /// margin for the bar to give some radius
  final EdgeInsetsGeometry? marginR;

  /// padding for the bar to give some radius
  final EdgeInsetsGeometry? paddingR;

  /// border radius
  final double? borderRadius;

  ///height
  final double? height;

  ///bgd colors for the nav bar
  final Color? backgroundColor;

  ///outline border colors for the nav bar
  final Color outlineBorderColor;

  ///borderWidth

  final double borderWidth;

  /// List of box shadow
  final List<BoxShadow> boxShadow;
  final bool enableFloatingNavBar;
  final bool enablePaddingAnimation;

  /// Color of the item's Splash Color
  ///
  /// To disable, use `Colors.transparent`
  final Color? splashColor;

  /// Color of the item's Splash Color
  ///
  /// To disable, use `Colors.transparent`
  final double? splashBorderRadius;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return enableFloatingNavBar
        ? BottomAppBar(
            color: Colors.transparent,
            padding: EdgeInsets.zero,
            elevation: 0,
            height: height! < 105 ? 105 : height,
            child: Padding(
              padding: marginR!,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: boxShadow, // Apply the shadow here
                  borderRadius: BorderRadius.circular(borderRadius!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius!),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      padding: paddingR,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius!),
                        border: Border.all(
                            width: borderWidth, color: outlineBorderColor),
                        color: backgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Body(
                            items: items,
                            currentIndex: currentIndex,
                            curve: curve,
                            duration: duration,
                            selectedItemColor: selectedItemColor,
                            theme: theme,
                            unselectedItemColor: unselectedItemColor,
                            onTap: onTap!,
                            itemPadding: itemPadding,
                            indicatorColor: indicatorColor,
                            splashColor: splashColor,
                            splashBorderRadius: splashBorderRadius),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: backgroundColor,
            child: Padding(
              padding: margin,
              child: Body(
                  items: items,
                  currentIndex: currentIndex,
                  curve: curve,
                  duration: duration,
                  selectedItemColor: selectedItemColor,
                  theme: theme,
                  unselectedItemColor: unselectedItemColor,
                  onTap: onTap!,
                  itemPadding: itemPadding,
                  indicatorColor: indicatorColor,
                  splashColor: splashColor,
                  splashBorderRadius: splashBorderRadius),
            ),
          );
  }
}

/// A tab to display in a [CrystalNavigationBar]
class CrystalNavigationBarItem2 {
  /// An icon to display.
  final icon;

  /// An icon to display.
  final IconData? unselectedIcon;

  ///badge
  final Badge? badge;

  /// A primary color to use for this tab.
  final Color? selectedColor;

  /// The color to display when this tab is not selected.
  final Color? unselectedColor;

  CrystalNavigationBarItem2({
    required this.icon,
    this.unselectedIcon,
    this.selectedColor,
    this.unselectedColor,
    this.badge,
  });
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.curve,
    required this.duration,
    required this.selectedItemColor,
    required this.theme,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.indicatorColor,
    // this.enablePaddingAnimation = true,
    this.splashBorderRadius,
    this.splashColor,
  });

  final List<CrystalNavigationBarItem2> items;
  final int currentIndex;
  final Curve curve;
  final Duration duration;
  final Color? selectedItemColor;
  final ThemeData theme;
  final Color? unselectedItemColor;
  final Function(int index) onTap;
  final EdgeInsets itemPadding;
  final Color? indicatorColor;
  // final bool enablePaddingAnimation;
  final Color? splashColor;
  final double? splashBorderRadius;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (final item in items)
          TweenAnimationBuilder<double>(
            tween: Tween(
              end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
            ),
            curve: curve,
            duration: duration,
            builder: (context, t, _) {
              final selectedColor =
                  item.selectedColor ?? selectedItemColor ?? theme.primaryColor;

              final unselectedColor = item.unselectedColor ??
                  unselectedItemColor ??
                  theme.iconTheme.color;

              return Material(
                color: Color.lerp(Colors.transparent, Colors.transparent, t),
                borderRadius: BorderRadius.circular(splashBorderRadius ?? 8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onTap.call(items.indexOf(item)),
                  focusColor: splashColor ?? selectedColor.withValues(alpha: (0.1 * 255).toDouble()),
                  highlightColor: splashColor ?? selectedColor.withValues(alpha: (0.1 * 255).toDouble()),
                  splashColor: splashColor ?? selectedColor.withValues(alpha: (0.1 * 255).toDouble()),
                  hoverColor: splashColor ?? selectedColor.withValues(alpha: (0.1 * 255).toDouble()),

                  child: Stack(children: <Widget>[
                    if (item.badge != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: item.badge!,
                      ),
                    Padding(
                      padding: itemPadding +
                          const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                      child: ImageIcon(
                        AssetImage(items.indexOf(item) == currentIndex
                            ? item.icon
                            : (item.unselectedIcon ?? item.icon)),
                        size: 24,
                        color: Color.lerp(unselectedColor, selectedColor, t),
                      ),
                    ),
                    ClipRect(
                      child: SizedBox(
                        height: 48,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          widthFactor: t,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: itemPadding.right / 0.63,
                                end: itemPadding.right),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: Color.lerp( selectedColor.withValues(alpha:0.0), selectedColor, t),
                                fontWeight: FontWeight.w600,
                              ),
                              child: Container(
                                height: 2,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: indicatorColor ?? selectedColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
      ],
    );
  }
}
