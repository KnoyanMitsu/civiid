import 'package:flutter/material.dart';

class TheFinalLayout extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final String subtitle;
  final int? startindex;
  final int? endindex;
  const TheFinalLayout({
    super.key,
    required this.children,
    this.title = "title",
    this.subtitle = "subtitle",
    this.startindex,
    this.endindex,
  });

  @override
  State<TheFinalLayout> createState() => _TheFinalLayoutState();
}

class _TheFinalLayoutState extends State<TheFinalLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.subtitle,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),

              if (widget.startindex != null && widget.endindex != null)
                LinearProgressIndicator(
                  value: widget.startindex! / widget.endindex!,
                  backgroundColor: Colors.grey,
                  color: Colors.black,
                ),
              SizedBox(height: 20),
              ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}
