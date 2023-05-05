import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart';

class MyCustomMultiSelectField<T> extends CustomMultiSelectField<T> {
  Color titleColor;
  MyCustomMultiSelectField({
    Key? key,
    required List<T> items,
    required String title,
    required void Function(List<T>) onSelectionDone,
    double? width,
    required this.titleColor,
    InputDecoration? decoration,
    String Function(dynamic T)? itemAsString,
    String? Function(List<T>)? validator,
    List<T>? initialValue,
    Color selectedItemColor = Colors.redAccent,
    bool enableAllOptionSelect = false,
  }) : super(
          key: key,
          items: items,
          title: title,
          onSelectionDone: onSelectionDone,
          width: width,
          decoration: decoration,
          itemAsString: itemAsString,
          validator: validator,
          initialValue: initialValue,
          selectedItemColor: selectedItemColor,
          enableAllOptionSelect: enableAllOptionSelect,
        );

  @override
  _MyCustomMultiSelectFieldState<T> createState() =>
      _MyCustomMultiSelectFieldState<T>();
}

class _MyCustomMultiSelectFieldState<T>
    extends State<MyCustomMultiSelectField<T>> {
  final TextEditingController _controller = TextEditingController();
  late List<T> selectedItems;
  late List<CustomMultiSelectDropdownItem<T>> _customMultiSelectDropdownItem;

  @override
  void initState() {
    selectedItems = widget.initialValue ?? [];
    _controller.text = widget.title;
    _customMultiSelectDropdownItem = _getDropdownItems(list: widget.items);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            Map<String, List<T>?> result =
                await CustomBottomSheetSelector<T>().customBottomSheet(
              buildContext: context,
              selectedItemColor: widget.selectedItemColor,
              initialSelection: selectedItems,
              buttonType: CustomDropdownButtonType.multiSelect,
              headerName: widget.title,
              dropdownItems: _customMultiSelectDropdownItem,
              isAllOptionEnable: widget.enableAllOptionSelect,
            );
            if (result[selectedList] != null &&
                widget.onSelectionDone != null) {
              widget.onSelectionDone!(result[selectedList]!);
              selectedItems = result[selectedList]!;
            }
            setState(() {});
          },
          child: SizedBox(
            width: widget.width ?? double.infinity,
            child: TextFormField(
              controller: _controller,
              readOnly: true,
              enabled: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                String? validationText;
                if (widget.validator != null) {
                  validationText = widget.validator!(selectedItems);
                }
                debugPrint("validationText:-> $validationText");
                return validationText;
              },
              style: defaultTextStyle(fontSize: 16, color: widget.titleColor),
              decoration: widget.decoration ??
                  InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    errorBorder: inputFieldBorder(color: errorColor),
                    errorMaxLines: 2,
                    errorStyle: defaultTextStyle(
                      color: errorColor,
                      fontSize: 11,
                    ),
                    floatingLabelStyle:
                        defaultTextStyle(color: labelColor, fontSize: 14),
                    labelStyle:
                        defaultTextStyle(color: labelColor, fontSize: 16),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                    suffixIconColor: Colors.black,
                    enabledBorder: inputFieldBorder(),
                    border: inputFieldBorder(),
                    focusedBorder: inputFieldBorder(),
                    focusedErrorBorder: inputFieldBorder(color: errorColor),
                  ),
            ),
          ),
        ),
        selectedItems.isNotEmpty
            ? Wrap(
                children: [
                  for (CustomMultiSelectDropdownItem<T> item
                      in _customMultiSelectDropdownItem)
                    selectedItems.contains(item.buttonObjectValue)
                        ? item.buttonText.length < 2
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 3),
                                child: Chip(
                                  label: Text(
                                    item.buttonText,
                                    style: defaultTextStyle(),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item.buttonText,
                                  style: defaultTextStyle(),
                                ),
                              )
                        : const SizedBox()
                ],
              )
            : const SizedBox(),
        selectedItems.isNotEmpty
            ? const SizedBox(
                height: 5,
              )
            : const SizedBox(),
      ],
    );
  }

  List<CustomMultiSelectDropdownItem<T>> _getDropdownItems(
      {required List<T> list}) {
    List<CustomMultiSelectDropdownItem<T>> _list =
        <CustomMultiSelectDropdownItem<T>>[];
    for (T _item in list) {
      _list.add(CustomMultiSelectDropdownItem(_item, _item.toString()));
    }
    return _list;
  }
}
