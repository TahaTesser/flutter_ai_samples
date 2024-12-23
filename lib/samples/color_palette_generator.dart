import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorPaletteGenerator extends StatefulWidget {
  const ColorPaletteGenerator({super.key});

  @override
  State<ColorPaletteGenerator> createState() => _ColorPaletteGeneratorState();
}

class _ColorPaletteGeneratorState extends State<ColorPaletteGenerator> {
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Palette Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _randomizeColors,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewColor,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(16),
              onReorder: _reorderColors,
              children: [
                for (int index = 0; index < _colors.length; index++)
                  ColorTile(
                    key: ValueKey(_colors[index]),
                    color: _colors[index],
                    onColorChanged: (color) => _updateColor(index, color),
                    onDelete: () => _deleteColor(index),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Palette Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Colors: ${_colors.length}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colors
                      .map((color) => Chip(
                            label: Text(
                              '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                              style: TextStyle(
                                color: color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            backgroundColor: color,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportPalette,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _reorderColors(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Color item = _colors.removeAt(oldIndex);
      _colors.insert(newIndex, item);
    });
  }

  void _randomizeColors() {
    setState(() {
      for (int i = 0; i < _colors.length; i++) {
        _colors[i] = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
      }
    });
  }

  void _addNewColor() {
    setState(() {
      _colors.add(
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      );
    });
  }

  void _updateColor(int index, Color color) {
    setState(() {
      _colors[index] = color;
    });
  }

  void _deleteColor(int index) {
    setState(() {
      _colors.removeAt(index);
    });
  }

  void _exportPalette() {
    // Here you could implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Palette exported! (Demo only)'),
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onDelete;

  const ColorTile({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () => _showColorPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: onColorChanged,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Simple color picker widget (you might want to use a package like flutter_colorpicker in practice)
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: Colors.primaries.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => widget.onColorChanged(Colors.primaries[index]),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.primaries[index],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 