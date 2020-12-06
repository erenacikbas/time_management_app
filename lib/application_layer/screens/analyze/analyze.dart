import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/components/Charts/bar_charts/large_bar_chart.dart';
import 'package:time_management_app/application_layer/components/Charts/pie_charts/pie_chart_1.dart';

class Analyze extends StatefulWidget {
  @override
  _AnalyzeState createState() => _AnalyzeState();
}

class _AnalyzeState extends State<Analyze> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text("Reports"),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            BarChartSample1(),
            PieChartSample2(),
          ],
        ),
      ),
    );
  }
}
