import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onApply;
  final List<String> selectedItems;
  final Color? notActiveColor;
  final Color? activeColor;
  final Color? backgroundColor;
  final Color? tileBackgroundColor;
  final Color? buttonColor;

  FilterDialog({
    Key? key,
    required this.items,
    required this.onApply,
    required this.selectedItems,
    this.notActiveColor,
    this.activeColor,
    this.backgroundColor,
    this.tileBackgroundColor,
    this.buttonColor,
  }) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Materie',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: widget.backgroundColor ?? Colors.white,
      content: SingleChildScrollView(
        child: Column(
          children: widget.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: CheckboxListTile(
                title: Text(
                  item,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    color: _selectedItems.contains(item)
                        ? widget.activeColor ?? Colors.red
                        : widget.notActiveColor ?? Colors.black,
                  ),
                ),
                visualDensity: VisualDensity.compact,
                tileColor: widget.tileBackgroundColor,
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                activeColor: widget.activeColor ?? Colors.blue,
                checkboxShape: CircleBorder(
                  side: BorderSide(
                    width: 0.5,
                    color: widget.notActiveColor ?? Colors.black,
                  ),
                ),
                value: _selectedItems.contains(item),
                onChanged: (value) {
                  setState(() {
                    if (value != null && value) {
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(500.0),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: widget.buttonColor ?? Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Apply'),
          onPressed: () {
            widget.onApply(_selectedItems);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200.0)),
              backgroundColor: widget.buttonColor ?? Colors.red),
        ),
      ],
    );
  }
}
