import 'package:flutter/cupertino.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/scaffolds/common.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class GtIssueCommentScreen extends StatefulWidget {
  final String owner;
  final String name;
  final String number;
  final bool isPr;
  final String body;
  final String id;
  const GtIssueCommentScreen(this.owner, this.name, this.number,
      {this.isPr = false, this.body = '', this.id = ''});

  @override
  _GtIssueCommentScreenState createState() => _GtIssueCommentScreenState();
}

class _GtIssueCommentScreenState extends State<GtIssueCommentScreen> {
  bool isEdit = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.body;
    if (_controller.text != '') {
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    final auth = Provider.of<AuthModel>(context);
    return CommonScaffold(
      title: Text(isEdit ? 'Update Comment' : 'New Comment'),
      body: Column(
        children: <Widget>[
          Padding(
            padding: CommonStyle.padding,
            child: CupertinoTextField(
              controller: _controller,
              style: TextStyle(color: theme.palette.text),
              placeholder: AppLocalizations.of(context)!.body,
              maxLines: 10,
            ),
          ),
          CupertinoButton.filled(
            child: const Text('Comment'),
            onPressed: () async {
              if (!isEdit) {
                await auth.fetchGitea(
                  '/repos/${widget.owner}/${widget.name}/${widget.isPr ? 'pulls' : 'issues'}/${widget.number}/comments',
                  requestType: 'POST',
                  body: {'body': _controller.text, 'repo': widget.name},
                );
              } else {
                await auth.fetchGitea(
                  '/repos/${widget.owner}/${widget.name}/${widget.isPr ? 'pulls' : 'issues'}/comments/${int.parse(widget.id)}',
                  requestType: 'PATCH',
                  body: {'body': _controller.text, 'repo': widget.name},
                );
              }
              Navigator.pop(context, '');
              await theme.push(
                context,
                '/gitea/${widget.owner}/${widget.name}/${widget.isPr ? 'pulls' : 'issues'}/${widget.number}',
                replace: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
