import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:myapp/models/dessert.dart';
import 'package:myapp/pages/datatable.dart';

class DessertDataSource extends DataTableSource {
  // Constructor for DessertDataSource class, takes a BuildContext argument
  DessertDataSource(this.context) {
    // Initialize the list of desserts
    desserts = <Dessert>[
      Dessert(
        'Frozen Yogurt',
        159,
        6.0,
        24,
        4.0,
        87,
        14,
        1,
      ),
      Dessert(
        'IceCream Sandwich',
        237,
        9.0,
        37,
        4.3,
        129,
        8,
        1,
      ),
      Dessert(
        'Eclair',
        262,
        16.0,
        24,
        6.0,
        337,
        6,
        7,
      ),
      Dessert(
        'Cupcake',
        305,
        3.7,
        67,
        4.3,
        413,
        3,
        8,
      ),
      Dessert(
        'Gingerbread',
        356,
        16.0,
        49,
        3.9,
        327,
        7,
        16,
      ),
      Dessert(
        'JellyBean',
        375,
        0.0,
        94,
        0.0,
        50,
        0,
        0,
      ),
      Dessert(
        'Lollipop',
        392,
        0.2,
        98,
        0.0,
        38,
        0,
        2,
      ),
      Dessert(
        'Honeycomb',
        408,
        3.2,
        87,
        6.5,
        562,
        0,
        45,
      ),
      Dessert(
        'Donut',
        452,
        25.0,
        51,
        4.9,
        326,
        2,
        22,
      ),
      Dessert(
        'Apple Pie',
        518,
        26.0,
        65,
        7.0,
        54,
        12,
        6,
      ),

      //11
      Dessert(
        'Donut 2',
        452,
        25.0,
        51,
        4.9,
        326,
        2,
        22,
      ),

      //12
      Dessert(
        'Apple Pie2',
        518,
        26.0,
        65,
        7.0,
        54,
        12,
        6,
      ),
    ];
  }

  // The BuildContext passed to the constructor
  final BuildContext context;

  // List of desserts
  late List<Dessert> desserts;

  // Number of selected desserts
  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    // Number formatter for percentages
    final format = NumberFormat.decimalPercentPattern(
      decimalDigits: 0,
    );
    // Make sure index is valid
    assert(index >= 0);
    if (index >= desserts.length) return null;

    // logging flutter
    var logger = Logger();
    logger.i(desserts.length);

    final dessert = desserts[index];

    // Create the DataRow with cells for each dessert property
    return DataRow.byIndex(
      index: index,
      selected: dessert.selected,
      onSelectChanged: (value) {
        // Update the selected count and dessert selection
        if (dessert.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(dessert.name)),
        DataCell(Text('${dessert.calories}')),
        DataCell(Text(dessert.fat.toStringAsFixed(1))),
        DataCell(Text('${dessert.carbs}')),
        DataCell(Text(dessert.protein.toStringAsFixed(1))),
        DataCell(Text('${dessert.sodium}')),
        DataCell(Text(format.format(dessert.calcium / 100))),
        DataCell(Text(format.format(dessert.iron / 100))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => desserts.length;

  @override
  int get selectedRowCount => _selectedCount;

  // Select or deselect all rows
  void selectAll(bool? checked) {
    for (final dessert in desserts) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = checked! ? desserts.length : 0;
    notifyListeners();
  }

  // Sort the desserts by a given field
  void sort<T>(Comparable<T> Function(Dessert d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  // Update the selected desserts
  void updateSelectedDesserts(RestorableDessertSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
      if (selectedRows.isSelected(i)) {
        dessert.selected = true;
        _selectedCount += 1;
      } else {
        dessert.selected = false;
      }
    }
    notifyListeners();
  }
}
