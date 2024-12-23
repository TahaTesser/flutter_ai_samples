// Generated on: 2023-04-19
// Model: claude-3-sonnet-20240229
// Description: A color palette picker widget that allows users to select multiple colors from a grid and display the selected colors in a wrap view.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class ColorPalettePicker extends StatefulWidget {
  static final String generatedAt = '2023-04-19';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A color palette picker widget that allows users to select multiple colors from a grid and display the selected colors in a wrap view.';
  static final String complexityLevel = 'intermediate';


  const ColorPalettePicker({super.key});

  @override
  _ColorPalettePickerState createState() => _ColorPalettePickerState();
}

class _ColorPalettePickerState extends State<ColorPalettePicker> {
  List<Color> selectedColors = [];

  void _addColor(Color color) {
    setState(() {
      selectedColors.add(color);
    });
  }

  void _removeColor(Color color) {
    setState(() {
      selectedColors.remove(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Palette Picker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 5,
              children: List.generate(20, (index) {
                final color = Colors.primaries[index % Colors.primaries.length];
                return GestureDetector(
                  onTap: () => _addColor(color),
                  child: Container(
                    color: color,
                    margin: const EdgeInsets.all(2),
                  ),
                );
              }),
            ),
          ),
          const Divider(),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: selectedColors.map((color) {
              return GestureDetector(
                onTap: () => _removeColor(color),
                child: Container(
                  color: color,
                  width: 40,
                  height: 40,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
