import 'package:flutter/material.dart';

class ColorTheme {
  static const ColorTheme defaultColorTheme = ColorTheme("Default", null, null);
  static const ColorTheme sepiaColorTheme =
      ColorTheme("Sepia", Color(0xffD4C69F), Color(0xff121212));
  static const ColorTheme lusiaColorTheme =
      ColorTheme("Lusia", Color(0xff59595B), Color(0xfffefefe));
  static const ColorTheme nightColorTheme =
      ColorTheme("Night", Colors.black, Color(0xfffefefe));
  static const List<ColorTheme> values = [
    defaultColorTheme,
    sepiaColorTheme,
    lusiaColorTheme,
    nightColorTheme,
  ];
  final String name;
  final Color? backgroundColor;
  final Color? textColor;

  const ColorTheme(this.name, this.backgroundColor, this.textColor);

  @override
  String toString() =>
      'ColorTheme{name: $name, backgroundColor: $backgroundColor, textColor: $textColor}';
}

class IconThemeSettings extends StatelessWidget {
  const IconThemeSettings(this.theme,
      {super.key,
      required this.colorSelected,
      required this.isSelected,
      this.onTap});
  final ColorTheme theme;
  final Color colorSelected;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: theme.backgroundColor,
            border: Border.all(
                width: 2,
                color: isSelected ? colorSelected : const Color(0xFFE0E0E0))),
      ));
}
