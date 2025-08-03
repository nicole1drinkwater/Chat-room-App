import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;

    return Text(text, style: GoogleFonts.notoSans (
      textStyle: baseStyle?.copyWith(color: color)
    ));
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.notoSans (
      textStyle: Theme.of(context).textTheme.headlineMedium
    ));
    }
  }

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.notoSans (
      textStyle: Theme.of(context).textTheme.titleMedium)
    );
  }
}

class StyledAppBarTitle extends StatelessWidget {
  const StyledAppBarTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.notoSans (textStyle: Theme.of(context).textTheme.titleMedium,
      ) 
    );
  }
}
