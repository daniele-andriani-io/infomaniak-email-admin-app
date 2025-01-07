import 'package:flutter/material.dart';

class PageWidget extends StatefulWidget {
  final String title;
  final IconButton? action;
  final Widget getBody;

  const PageWidget({
    super.key,
    required this.title,
    this.action,
    required this.getBody,
  });

  @override
  State<PageWidget> createState() {
    return _PageWidgetState();
  }
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.action != null
            ? [
                widget.action!,
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: widget.getBody,
      ),
    );
  }
}
