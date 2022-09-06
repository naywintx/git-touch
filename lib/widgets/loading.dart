import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/theme.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  final bool more;

  const Loading({this.more = false});

  Widget _buildIndicator(BuildContext context) {
    switch (Provider.of<ThemeModel>(context).theme) {
      case AppThemeType.cupertino:
        return const CupertinoActivityIndicator(radius: 12);
      default:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: more ? 20 : 100),
        child: _buildIndicator(context),
      ),
    );
  }
}
