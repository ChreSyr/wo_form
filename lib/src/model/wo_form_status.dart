import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wo_form/wo_form.dart';

part 'wo_form_status.freezed.dart';
part 'wo_form_status.g.dart';

@freezed
sealed class WoFormStatus with _$WoFormStatus {
  const factory WoFormStatus.initial() = InitialStatus;
  const factory WoFormStatus.inProgress({
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default([])
    List<WoFormInputError> errors,
  }) = InProgressStatus;
  const factory WoFormStatus.submitting() = SubmittingStatus;
  const factory WoFormStatus.submitError({
    @JsonKey(includeToJson: false, includeFromJson: false) Object? error,
    @JsonKey(includeToJson: false, includeFromJson: false)
    StackTrace? stackTrace,
  }) = SubmitErrorStatus;
  const factory WoFormStatus.submitSuccess() = SubmitSuccessStatus;

  factory WoFormStatus.fromJson(Map<String, dynamic> json) =>
      _$WoFormStatusFromJson(json);
}

extension InProgressStatusX on InProgressStatus {
  WoFormInputError? getError({required String path}) =>
      errors.firstWhereOrNull((error) => error.path == path);
}
