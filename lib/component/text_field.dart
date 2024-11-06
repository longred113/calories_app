import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final bool isDataSelected;
  final bool isNumberInput;
  final bool? isMultiSelect;
  final bool? isRead;
  final List<SelectedListItem>? selectList;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isDataSelected,
    required this.isNumberInput,
    this.isMultiSelect,
    this.selectList,
    this.isRead,
    this.onChanged,
    super.key,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        isDismissible: true,
        bottomSheetTitle: const Text(
          "kCities",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        maxSelectedItems: 3,
        clearButtonChild: const Text(
          'Clear',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: widget.selectList ?? [],
        onSelected: (List<dynamic> selectedList) {
          if (widget.isMultiSelect == false &&
              selectedList.isNotEmpty &&
              selectedList.first is SelectedListItem) {
            // Lấy tên của mục đã chọn và cập nhật vào TextField
            widget.textEditingController.text =
                (selectedList.first as SelectedListItem)
                    .name
                    .split('\n')
                    .first
                    .trim();
            showSnackBar(widget.textEditingController.text);
          } else {
            List<String> list = [];
            for (var item in selectedList) {
              if (item is SelectedListItem) {
                String name = item.name.split('\n').first;
                list.add(name.trim());
              }
            }
            widget.textEditingController.text = list.join(', ');
          }
        },
        enableMultipleSelection: widget.isMultiSelect ?? false,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          readOnly: widget.isRead ?? false,
          inputFormatters: widget.isNumberInput
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          keyboardType:
              widget.isNumberInput ? TextInputType.number : TextInputType.text,
          onChanged: (value) => widget.onChanged?.call(value),
          onTap: widget.isDataSelected
              ? () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap();
                }
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            contentPadding:
                const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
            hintText: widget.hint,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
