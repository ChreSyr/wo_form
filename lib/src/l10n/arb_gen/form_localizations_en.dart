import 'package:intl/intl.dart' as intl;

import 'form_localizations.dart';

/// The translations for English (`en`).
class FormLocalizationsEn extends FormLocalizations {
  FormLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get discardChanges => 'Discard changes';

  @override
  String get discardChangesQuestion => 'Discard unsaved changes ?';

  @override
  String get errorOccurred => 'An error has occured.';

  @override
  String formError(String code) {
    String _temp0 = intl.Intl.selectLogic(
      code,
      {
        'other': 'Unknown error.',
        'empty': 'This field is required.',
        'invalid': 'This value is invalid.',
        'maxBound': 'Maximum limit exceeded.',
        'minBound': 'Minimum limit exceeded.',
      },
    );
    return '$_temp0';
  }

  @override
  String get keepEditing => 'Keep editing';

  @override
  String regexPatternUnmatched(String code) {
    String _temp0 = intl.Intl.selectLogic(
      code,
      {
        'other': 'Unknown regex pattern.',
        'email': 'Doesn\'t appear to be an email address.',
        'password': 'Too weak. A password must contain a lowercase letter, an uppercase letter, a number and at least 8 characters.',
        'username': 'Minimum 3 characters, only alphanumeric\nSymbols accepted : _ - .\nOnly one symbol in a row, and only in the middle',
      },
    );
    return '$_temp0';
  }

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';
}
