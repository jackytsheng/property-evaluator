import 'package:flutter/material.dart';
import 'package:property_evaluator/components/close_delete_dialog.dart';
import 'package:property_evaluator/components/property_card.dart';
import 'package:property_evaluator/constants/route.dart';
import 'package:property_evaluator/model/property.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({
    super.key,
    required this.toggleThemeMode,
    required this.currentThemeMode,
    required this.properties,
    required this.addProperty,
    required this.toggleEditMode,
    required this.isEditMode,
    required this.selectedPropertyIds,
    required this.togglePropertySelect,
    required this.export,
    required this.deleteAllSelected,
  });

  final Function() toggleThemeMode;
  final Function(BuildContext context) addProperty;
  final Function() toggleEditMode;
  final Function() export;
  final Function(String propertyId) togglePropertySelect;
  final Function() deleteAllSelected;
  final ThemeMode currentThemeMode;
  final bool isEditMode;
  final List<String> selectedPropertyIds;
  final List<PropertyEntity> properties;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              actions: <Widget>[
                IconButton(
                    iconSize: 40,
                    tooltip: currentThemeMode == ThemeMode.light
                        ? "Light mode"
                        : "Dark mode",
                    icon: Icon(
                        currentThemeMode == ThemeMode.light
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 30),
                    onPressed: toggleThemeMode),
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                        onPressed: toggleEditMode,
                        child: const Text('Select'))),
              ],
              scrolledUnderElevation: 10,
              elevation: 10,
              title: const Text("Property Evaluator",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                    children: properties
                        .map<PropertyCard>((property) => PropertyCard(
                              isEditMode: isEditMode,
                              isSelected: selectedPropertyIds
                                  .contains(property.propertyId),
                              property: property,
                              onToggle: () =>
                                  togglePropertySelect(property.propertyId),
                            ))
                        .toList()),
              ),
            ),
            floatingActionButton: isEditMode
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      addProperty(context);
                    },
                    shape: const CircleBorder(),
                    tooltip: 'Add new address',
                    child: const Icon(
                      Icons.add_home_work_rounded,
                      size: 30,
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              height: isEditMode ? 100 : 80,
              clipBehavior: Clip.hardEdge,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: isEditMode
                  ? Column(children: [
                      Text(
                        "${selectedPropertyIds.length} / ${properties.length} Selected",
                        style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, COMPARE_ROUTE);
                                  toggleEditMode();
                                },
                                icon: const Icon(Icons.bar_chart_rounded),
                                label: const Text("Compare")),
                            ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                              child: CloseDeleteDialog(
                                                  onDelete: deleteAllSelected,
                                                  children: [
                                                Text("Warning !",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium),
                                                const SizedBox(height: 10),
                                                Text(
                                                    "Doing so will remove all notes related to these properties! Delete properties?",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                                const SizedBox(height: 20)
                                              ])));
                                },
                                icon: const Icon(Icons.delete_rounded),
                                label: const Text("Remove")),
                          ])
                    ])
                  : Row(children: <Widget>[
                      IconButton(
                        iconSize: 40,
                        tooltip: 'Comparison',
                        icon: const Icon(Icons.bar_chart_rounded),
                        onPressed: () {
                          Navigator.pushNamed(context, COMPARE_ROUTE);
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        tooltip: 'Criteria',
                        icon: const Icon(Icons.assignment_rounded),
                        onPressed: () {
                          Navigator.pushNamed(context, CRITERIA_ROUTE);
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        iconSize: 40,
                        tooltip: 'Additional cost',
                        icon: const Icon(Icons.price_change_rounded),
                        onPressed: () {
                          Navigator.pushNamed(context, ADDITIONAL_COST_ROUTE);
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        tooltip: 'Export stored files',
                        icon: const Icon(Icons.download_for_offline_rounded),
                        onPressed: export,
                      )
                    ]),
            )));
  }
}
