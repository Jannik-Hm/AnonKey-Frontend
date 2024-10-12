import 'package:flutter/material.dart';

class ClickableTile extends StatefulWidget {
  final void Function()? onTap;
  final Widget? leading;
  final Widget? title;
  final Widget? subTitle;
  final Widget? trailing;

  const ClickableTile({
    super.key,
    this.onTap,
    this.leading,
    this.title,
    this.subTitle,
    this.trailing,
  });

  @override
  State<StatefulWidget> createState() => _ClickableTile();
}

class _ClickableTile extends State<ClickableTile> {
  late Widget? _leading;
  late Widget? _title;
  late Widget? _subTitle;
  late Widget? _trailing;

  @override
  void initState() {
    super.initState();
    _leading = widget.leading;
    _title = widget.title;
    _subTitle = widget.subTitle;
    _trailing = widget.trailing;
    // Initialize the mutable object from the widget field
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3,
      color: theme.colorScheme.tertiary,
      child: InkWell(
        onTap: widget.onTap,
        child: ListTile(
          mouseCursor: SystemMouseCursors.click,
          leading: _leading,
          title: _title,
          subtitle: _subTitle,
          trailing: _trailing,
        ),
      ),
    );
  }
}
