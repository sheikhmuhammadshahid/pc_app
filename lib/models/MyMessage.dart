import 'dart:convert';

class MyMessage {
  String todo;
  String value;
  MyMessage({
    required this.todo,
    required this.value,
  });

  MyMessage copyWith({
    String? todo,
    String? value,
  }) {
    return MyMessage(
      todo: todo ?? this.todo,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'todo': todo});
    result.addAll({'value': value});

    return result;
  }

  factory MyMessage.fromMap(Map<String, dynamic> map) {
    return MyMessage(
      todo: map['todo'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyMessage.fromJson(String source) =>
      MyMessage.fromMap(json.decode(source));

  @override
  String toString() => 'MyMessage(todo: $todo, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyMessage && other.todo == todo && other.value == value;
  }

  @override
  int get hashCode => todo.hashCode ^ value.hashCode;
}
