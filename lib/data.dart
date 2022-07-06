/// value : 1
/// tenor : "2.25% p.a"

class SliderData {
  SliderData({
    int? value,
    String? tenor,
  }) {
    _value = value;
    _tenor = tenor;
  }

  SliderData.fromJson(dynamic json) {
    _value = json['value'];
    _tenor = json['tenor'];
  }
  int? _value;
  String? _tenor;
  SliderData copyWith({
    int? value,
    String? tenor,
  }) =>
      SliderData(
        value: value ?? _value,
        tenor: tenor ?? _tenor,
      );
  int? get value => _value;
  String? get tenor => _tenor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['tenor'] = _tenor;
    return map;
  }
}
