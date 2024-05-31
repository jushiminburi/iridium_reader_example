// Copyright (c) 2022 Mantano. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:equatable/equatable.dart';

class TextAligns with EquatableMixin {
  static const TextAligns left = TextAligns._(0, "left");
  static const TextAligns center = TextAligns._(1, "center");
  static const TextAligns right = TextAligns._(2, "right");
  static const TextAligns justify = TextAligns._(3, "justify");
  static const List<TextAligns> values = [
    left,
    center,
    right,
    justify,
  ];

  final int id;
  final String name;

  const TextAligns._(this.id, this.name);

  @override
  List<Object> get props => [id];

  static TextAligns from(int id) =>
      values.firstWhere((type) => type.id == id, orElse: () => left);
  @override
  String toString() => 'TextAlign{id: $id, name: $name}';
}
