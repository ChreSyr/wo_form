import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wo_form/wo_form.dart';

class InputConverter
    extends JsonConverter<WoFormNodeMixin, Map<String, dynamic>> {
  const InputConverter();

  @override
  WoFormNodeMixin fromJson(Map<String, dynamic> json) {
    try {
      return WoFormInput.fromJson(json);
    } on CheckedFromJsonException {
      return WoFormNode.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson(WoFormNodeMixin object) => object.toJson();
}