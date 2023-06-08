import 'package:flutter/material.dart';
import 'package:property_evaluator/components/themed_app_bar.dart';
import 'package:property_evaluator/constants/route.dart';
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
        appBar: const ThemedAppBar(
          title: "Compare property",
          helpMessage: """
1. Legend list can be scrolled
        
2. Click legend to toggle visibility

3. Click a single bar to view score

4. Hold down to view all score
        """,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: selectedPropertyIds.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Selected Properties to Compare"),
                      )
                    : SfCartesianChart(
                        margin: const EdgeInsets.only(
                            top: 5, bottom: 30, left: 15, right: 35),
                        primaryYAxis: NumericAxis(minimum: 0, maximum: 10),
                        primaryXAxis: CategoryAxis(
                            labelRotation: 90,
                            majorTickLines: const MajorTickLines(width: 0),
                            majorGridLines: const MajorGridLines(width: 0)),
                        isTransposed: true,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
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
