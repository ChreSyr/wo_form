import 'package:flutter/material.dart';
import 'package:package_atomic_design/package_atomic_design.dart';
import 'package:wo_form/wo_form.dart';

class SelectField<T> extends StatelessWidget {
  const SelectField(this.data, {super.key});

  final WoFieldData<SelectInput<T>, List<T>, SelectInputUiSettings<T>> data;

  @override
  Widget build(BuildContext context) {
    final selectedValues = data.value ?? [];

    if (data.input.maxCount == 1) {
      return switch (data.uiSettings.displayMode) {
        null || SelectFieldDisplayMode.tile => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final headerData = WoFormInputHeaderData(
                    labelText: data.uiSettings.labelText,
                    helperText: data.uiSettings.helperText,
                  );

                  return (data.uiSettings.headerBuilder ??
                          WoFormTheme.of(context)?.inputHeaderBuilder ??
                          InputHeader.new)
                      .call(headerData);
                },
              ),
              ...data.input.availibleValues.map(
                (value) {
                  final subtitle =
                      data.uiSettings.helpValueBuilder?.call(value);
                  return RadioListTile<T>(
                    toggleable: true,
                    value: value,
                    groupValue: data.value?.firstOrNull,
                    onChanged: data.onValueChanged == null
                        ? null
                        : (_) => onUniqueChoice(value),
                    title: data.uiSettings.valueBuilder?.call(value) ??
                        Text(value.toString()),
                    subtitle: subtitle,
                  );
                },
              ),
            ],
          ),
        SelectFieldDisplayMode.chip => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final headerData = WoFormInputHeaderData(
                    labelText: data.uiSettings.labelText,
                    helperText: data.uiSettings.helperText,
                  );

                  return (data.uiSettings.headerBuilder ??
                          WoFormTheme.of(context)?.inputHeaderBuilder ??
                          InputHeader.new)
                      .call(headerData);
                },
              ),
              ListTile(
                title: SearchField<T>.uniqueChoice(
                  values: data.input.availibleValues,
                  onSelected:
                      data.onValueChanged == null ? null : onUniqueChoice,
                  selectedValue: selectedValues.firstOrNull,
                  valueBuilder: data.uiSettings.valueBuilder,
                  helpValueBuilder: data.uiSettings.helpValueBuilder,
                  hintText: data.uiSettings.hintText,
                  searcher: data.uiSettings.searcher,
                ),
              ),
            ],
          ),
      };
    } else {
      return Column(
        children: [
          Builder(
            builder: (context) {
              final headerData = WoFormInputHeaderData(
                labelText: data.uiSettings.labelText,
                helperText: data.uiSettings.helperText,
                trailing: SearchField<T>.multipleChoices(
                  values: data.input.availibleValues,
                  onSelected:
                      data.onValueChanged == null ? null : onMultipleChoice,
                  selectedValues: selectedValues,
                  valueBuilder: data.uiSettings.valueBuilder,
                  helpValueBuilder: data.uiSettings.helpValueBuilder,
                  hintText: data.uiSettings.hintText,
                  searcher: data.uiSettings.searcher,
                  builder: (onPressed) => IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add),
                  ),
                ),
                shrinkWrap: false,
              );

              return (data.uiSettings.headerBuilder ??
                      WoFormTheme.of(context)?.inputHeaderBuilder ??
                      InputHeader.new)
                  .call(headerData);
            },
          ),
          if (selectedValues.isNotEmpty)
            ListTile(
              title: Wrap(
                spacing: WoSize.small,
                children: [
                  ...selectedValues.map(
                    (v) => _MultipleSelectChip(
                      helper: data.uiSettings.helpValueBuilder?.call(v),
                      onDeleted: data.onValueChanged == null
                          ? null
                          : () => onMultipleChoice(v),
                      label: data.uiSettings.valueBuilder?.call(v) ??
                          Text(v.toString()),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }
  }

  void onUniqueChoice(T value) {
    data.onValueChanged?.call(
      value == null
          ? <T>[]
          : data.value?.contains(value) ?? false
              ? <T>[]
              : [value],
    );
  }

  void onMultipleChoice(T value) {
    final selectedSet = data.value?.toSet() ?? {};
    if (!selectedSet.add(value)) selectedSet.remove(value);
    data.onValueChanged?.call(selectedSet.toList());
  }
}

class _MultipleSelectChip extends StatelessWidget {
  const _MultipleSelectChip({
    required this.label,
    this.onDeleted,
    this.helper,
  });

  final Widget label;
  final VoidCallback? onDeleted;
  final Widget? helper;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: label,
      backgroundColor: Theme.of(context).colorScheme.cardColor,
      onDeleted: onDeleted,
      deleteButtonTooltipMessage: '',
      onPressed: helper == null
          ? null
          : () => showInfoPopover(
                context: context,
                builder: (popoverContext, pop) => WoPadding.allMedium(
                  child: helper,
                ),
              ),
    );
  }
}
