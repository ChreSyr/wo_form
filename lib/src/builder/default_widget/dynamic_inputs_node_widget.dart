import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';

class DynamicInputsNodeWidget extends StatelessWidget {
  const DynamicInputsNodeWidget(this.data, {super.key});

  final WoFieldData<DynamicInputsNode, List<WoFormElementMixin>,
      DynamicInputsNodeUiSettings> data;

  @override
  Widget build(BuildContext context) {
    void onAddChoice(WoFormElementMixin inputFromTemplate) {
      final input = inputFromTemplate.withUid();

      data.onValueChanged?.call(List.from(data.value ?? [])..add(input));

      final form = context.read<WoForm>();
      final valuesCubit = context.read<WoFormValuesCubit>();
      final values = valuesCubit.state;
      for (final inputPath in input.getAllInputPaths(
        values: values,
        parentPath: data.inputPath,
      )) {
        final input = form.getInput(path: inputPath, values: values);
        if (input is WoFormInput) {
          valuesCubit.onValueChanged(
            inputPath: inputPath,
            value: input.defaultValue,
          );
        }
      }
    }

    if (data.input.templates.isEmpty) return const SizedBox.shrink();

    final addButton = data.input.templates.length == 1
        ? IconButton.filled(
            onPressed: data.onValueChanged == null
                ? null
                : () => onAddChoice(data.input.templates.first.input),
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.onPrimary,
          )
        : SearchField<DynamicInputTemplate>.multipleChoices(
            values: data.input.templates,
            onSelected: data.onValueChanged == null
                ? null
                : (template) => onAddChoice(template.input),
            valueBuilder: (template) => Text(template?.labelText ?? ''),
            helpValueBuilder: (template) => (template.helperText ?? '').isEmpty
                ? null
                : Text(template.helperText ?? ''),
            builder: (onPressed) => IconButton.filled(
              onPressed: onPressed,
              icon: const Icon(Icons.add),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );

    final headerData = WoFormInputHeaderData(
      labelText: data.uiSettings.labelText,
      helperText: data.uiSettings.helperText,
      trailing: addButton,
      shrinkWrap: false,
    );

    return Column(
      children: [
        (WoFormTheme.of(context)?.inputHeaderBuilder ?? InputHeader.new)
            .call(headerData),
        ...?data.value?.map(
          (e) => DeletableField(
            onDelete: () => onRemoveChoice(e),
            child: WoFormElementBuilder(
              inputPath: '${data.inputPath}/${e.id}',
              key: Key(
                '${data.inputPath}/${e.id}',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onRemoveChoice(WoFormElementMixin input) =>
      data.onValueChanged?.call(List.from(data.value ?? [])..remove(input));
}
