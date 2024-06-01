import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';

class BooleanField<T extends WoFormCubit> extends StatelessWidget {
  const BooleanField({
    required this.input,
    this.theme,
    super.key,
  });

  final BooleanInput Function(WoForm form) input;
  final BooleanFieldSettings? theme;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();

    final themeFromInput = input(cubit.state).fieldSettings;
    final mergedSettings = theme?.merge(themeFromInput) ?? themeFromInput;

    return BlocSelector<T, WoForm, BooleanInput>(
      selector: input,
      builder: (context, input) {
        final onOffType = switch (mergedSettings.onOffType) {
          null || BooleanFieldOnOffType.switchButton => Switch(
              value: input.value,
              onChanged: (value) => cubit.onInputChanged(
                input: input.copyWith(value: value),
              ),
            ),
          BooleanFieldOnOffType.checkbox => Checkbox(
              value: input.value,
              onChanged: (value) => value == null
                  ? null
                  : cubit.onInputChanged(input: input.copyWith(value: value)),
            ),
        };
        final onOffTypeIsLeading = switch (mergedSettings.onOffPosition) {
          ListTileControlAffinity.leading => true,
          ListTileControlAffinity.trailing => false,
          null || ListTileControlAffinity.platform => switch (
                mergedSettings.onOffType) {
              null || BooleanFieldOnOffType.switchButton => false,
              BooleanFieldOnOffType.checkbox => true,
            }
        };

        return ListTile(
          leading: onOffTypeIsLeading ? onOffType : null,
          title: Text(mergedSettings.labelText ?? ''),
          trailing: onOffTypeIsLeading ? null : onOffType,
          onTap: () => cubit.onInputChanged(
            input: input.copyWith(value: !input.value),
          ),
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
