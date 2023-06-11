import 'package:flutter/material.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/property.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CompareRoute extends StatelessWidget {
  const CompareRoute(
      {super.key,
      required this.propertiesMap,
      required this.selectedPropertyIds,
      required this.criteriaItemsMap});

  final Map<String, PropertyEntity> propertiesMap;
  final Map<String, CriteriaItemEntity> criteriaItemsMap;
  final List<String> selectedPropertyIds;

  @override
  Widget build(BuildContext context) {
    final List<String> chartData = criteriaItemsMap.keys.toList();
    return Scaffold(
        appBar: ThemedAppBar(title: "Compare property", childrenMessages: [
          Text("1. Click legend label to toggle visibility of data",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("2. Legend labels can be scrolled horizontally",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("3. Single bar can be clicked to view score",
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text("4. Hold down the chart to view the comparsion",
              style: Theme.of(context).textTheme.bodySmall),
        ]),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
                child: selectedPropertyIds.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Selected Properties to Compare"),
                      )
                    : SfCartesianChart(
                        margin: const EdgeInsets.only(
                            top: 5, bottom: 30, left: 0, right: 25),
                        primaryYAxis: NumericAxis(minimum: 0, maximum: 10),
                        primaryXAxis: CategoryAxis(
                            majorTickLines: const MajorTickLines(width: 0),
                            majorGridLines: const MajorGridLines(width: 0)),
                        isTransposed: true,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                          width: '300%',
                          isVisible: true,
                        ),
                        selectionType: SelectionType.series,
                        trackballBehavior: TrackballBehavior(
                            lineWidth: 0,
                            tooltipDisplayMode:
                                TrackballDisplayMode.groupAllPoints,
                            enable: true,
                            markerSettings: const TrackballMarkerSettings(
                                borderWidth: 5,
                                markerVisibility:
                                    TrackballVisibilityMode.visible)),
                        series: selectedPropertyIds.map((propertyId) {
                          var property = propertiesMap[propertyId]!;
                          return ColumnSeries<String, String>(
                            dataSource: chartData,
                            name: property.address,
                            xValueMapper: (String criteriaId, __) =>
                                criteriaItemsMap[criteriaId]?.criteriaName,
                            yValueMapper: (String criteriaId, __) => property
                                .propertyAssessmentMap[criteriaId]?.score,
                          );
                        }).toList()))));
  }
}
