import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_atomic_design/package_atomic_design.dart';
import 'package:wo_form/example/form_creator/num_input_node.dart';
import 'package:wo_form/example/form_creator/string_input_node.dart';
import 'package:wo_form/example/utils/readable_json.dart';
import 'package:wo_form/wo_form.dart';

class FormCreatorPage extends StatelessWidget {
  const FormCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final woFormCreator = WoForm(
      initialStatus: const InvalidValuesStatus(),
      canQuit: (context) async =>
          context.read<WoFormStatusCubit>().state is InitialStatus ||
                  context.read<WoFormStatusCubit>().state is SubmitSuccessStatus
              ? true
              : await showActionDialog(
                  pageContext: context,
                  title: 'Supprimer le formulaire ?',
                  actionText: 'Supprimer le formulaire',
                  onAction: () => true,
                  cancelText: "Continuer d'éditer",
                ),
      inputs: [
        const InputsNode(
          id: 'uiSettings',
          uiSettings: InputsNodeUiSettings(
            labelText: 'Paramètres généraux',
            displayMode: InputsNodeDisplayMode.tapToExpand,
          ),
          inputs: [
            StringInput(
              id: 'titleText',
              uiSettings:
                  StringInputUiSettings(labelText: 'Titre du formulaire'),
            ),
            StringInput(
              id: 'submitText',
              uiSettings: StringInputUiSettings(
                labelText: 'Label du bouton de validation',
              ),
            ),
          ],
        ),
        // InputsNode(
        //   id: 'inputs',
        //   exportSettings: const ExportSettings(exportType: ExportType.list),
        //   inputs: [
        //     createStringInputNode(id: idGenerator.generateId()),
        //     createNumInputNode(id: idGenerator.generateId()),
        //   ],
        // ),
        DynamicInputsNode(
          id: 'inputs',
          exportSettings: const ExportSettings(exportType: ExportType.list),
          templates: [
            DynamicInputTemplate(
              labelText: 'Saisie de texte',
              input: createStringInputNode(id: 'stringInput'),
            ),
            DynamicInputTemplate(
              labelText: 'Saisie de nombre',
              input: createNumInputNode(id: 'numInput'),
            ),
          ],
          uiSettings: const DynamicInputsNodeUiSettings(
            labelText: 'Ajouter une saisie',
          ),
        ),
        WidgetNode(
          id: 'jsonClipboarder',
          builder: (context) => const JsonClipboarder(),
        ),
      ],
      uiSettings: WoFormUiSettings(
        titleText: "Création d'un formulaire",
        submitMode: const WoFormSubmitMode.standard(
          buttonPosition: SubmitButtonPosition.appBar,
          disableSubmitMode: DisableSubmitButton.whenInvalid,
        ),
        submitButtonBuilder: (data) => TextButton(
          onPressed: data.onPressed,
          child: const Text('Exporter'),
        ),
      ),
      onSubmitSuccess: (context) {
        try {
          final form = WoForm.fromJson(
            context.read<WoForm>().export(
                  context.read<WoFormValuesCubit>().state,
                ) as Map<String, dynamic>,
          );
          context.pushPage(
            Hero(
              tag: 'createdForm',
              child: form.copyWith(onSubmitSuccess: showJsonDialog).toPage(),
            ),
          );
        } catch (e) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.error),
              content: Text(e.toString()),
            ),
          );
          return;
        }
      },
    );

    return woFormCreator.toPage();
  }
}

class JsonClipboarder extends StatefulWidget {
  const JsonClipboarder({super.key});

  @override
  State<JsonClipboarder> createState() => _JsonClipboarderState();
}

class _JsonClipboarderState extends State<JsonClipboarder> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    final values = context.watch<WoFormValuesCubit>().state;

    final form = context.read<WoForm>();
    final woFormL10n = context.read<WoFormL10n>();

    final errorsText = woFormL10n.errors(form.getErrors(values).length);

    return Column(
      children: [
        const SizedBox(height: 32),
        InputHeader(
          WoFormInputHeaderData(
            labelText: 'Prévisualisation',
            trailing: IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: context.read<WoFormValuesCubit>().submit,
            ),
            shrinkWrap: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Builder(
            builder: (context) {
              WoForm? createdForm;
              try {
                createdForm = WoForm.fromJson(
                  form.export(values) as Map<String, dynamic>,
                );
              } catch (_) {}

              return InputDecorator(
                decoration: InputDecoration(
                  helperText: ' ',
                  errorText: createdForm == null ? ' ' : null,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(2),
                ),
                child: createdForm != null
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: Hero(
                          tag: 'createdForm',
                          child: createdForm
                              .copyWith(
                                onSubmitSuccess: showJsonDialog,
                                canQuit: (_) async => false,
                              )
                              .toPage(key: UniqueKey()),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$errorsText',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
        ListTile(
          onTap: () {
            final values = context.read<WoFormValuesCubit>().state;
            Clipboard.setData(
              ClipboardData(
                text: jsonEncode(
                  form.export(values),
                ),
              ),
            );
            setState(() => copied = true);
            Future.delayed(
              const Duration(seconds: 4),
              () => setState(() => copied = false),
            );
          },
          leading: copied ? const Icon(Icons.check) : const Icon(Icons.copy),
          title: const Text(
            'Copier le formulaire',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ExpansionTile(
          title: const Text(''),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(readableJson(form.export(values))),
          ],
        ),
      ],
    );
  }
}
