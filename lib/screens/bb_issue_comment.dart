import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/scaffolds/common.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class BbIssueCommentScreen extends StatefulWidget {
  final String owner;
  final String name;
  final String number;
  const BbIssueCommentScreen(this.owner, this.name, this.number);

  @override
  _BbIssueCommentScreenState createState() => _BbIssueCommentScreenState();
}

class _BbIssueCommentScreenState extends State<BbIssueCommentScreen> {
  var _body = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);
    return CommonScaffold(
      title: const Text('New Comment'),
      body: Column(
        children: <Widget>[
          Padding(
            padding: CommonStyle.padding,
            child: CupertinoTextField(
              style: TextStyle(color: theme.palette.text),
              placeholder: AppLocalizations.of(context)!.body,
              onChanged: (v) {
                setState(() {
                  _body = v;
                });
              },
              maxLines: 10,
            ),
          ),
          CupertinoButton.filled(
            child: const Text('Comment'),
            onPressed: () async {
              await auth.fetchBb(
                '/repositories/${widget.owner}/${widget.name}/issues/${widget.number}/comments',
                isPost: true,
                body: {
                  'content': {'raw': _body}
                },
              );
              Navigator.pop(context, true);
              await theme.push(
                context,
                '/bitbucket/${widget.owner}/${widget.name}/issues/${widget.number}',
                replace: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
