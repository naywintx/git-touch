import 'package:flutter/material.dart';
import 'package:git_touch/screens/organization.dart';
import 'package:git_touch/screens/user.dart';
import 'package:git_touch/widgets/avatar.dart';
import 'package:git_touch/widgets/link.dart';
import 'package:git_touch/widgets/text_contains_organization.dart';
import 'package:primer/primer.dart';

const userGqlChunk = '''
  login
  name
  avatarUrl
  bio
''';

class UserItem extends StatelessWidget {
  final String login;
  final String name;
  final String avatarUrl;
  final String bio;
  final bool inUserScreen;
  final bool isOrganization;

  UserItem({
    this.login,
    this.name,
    this.avatarUrl,
    this.bio,
    this.inUserScreen = false,
    this.isOrganization = false,
  });
  UserItem.fromData(
    data, {
    this.isOrganization = false,
    this.inUserScreen = false,
  })  : login = data['login'],
        name = data['name'],
        avatarUrl = data['avatarUrl'],
        bio = data['bio'];

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Avatar(url: avatarUrl, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      name ?? login,
                      style: TextStyle(
                        color: PrimerColors.blue500,
                        fontSize: inUserScreen ? 18 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      login,
                      style: TextStyle(
                          color: PrimerColors.gray700,
                          fontSize: inUserScreen ? 16 : 14),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                if (bio != null && bio.isNotEmpty)
                  TextContainsOrganization(
                    bio,
                    style: TextStyle(
                        color: PrimerColors.gray700,
                        fontSize: inUserScreen ? 15 : 14),
                  ),
              ],
            ),
          )
        ],
      ),
    );

    if (inUserScreen) {
      return widget;
    } else {
      return Link(
          screenBuilder: (_) =>
              isOrganization ? OrganizationScreen(login) : UserScreen(login),
          child: widget);
    }
  }
}
