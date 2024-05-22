// Copyright (c) 2022 Mantano. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/src/common/data/repository/reader_theme_repository.dart';

class ReaderThemeBloc extends Bloc<ThemeEvent, ReaderThemeState> {
  ReaderThemeBloc(ReaderThemeConfig? defaultTheme)
      : super(
            ReaderThemeState(defaultTheme ?? ReaderThemeConfig.defaultTheme)) {
    ReaderThemeRepository readerThemeRepository = ReaderThemeRepository();
    on<ReaderThemeInitEvent>((event, emit) async {
      final theme = await readerThemeRepository.currenthemeConfig();
      emit(ReaderThemeState(theme.copy()));
    });
    on<ReaderThemeEvent>((event, emit) async {
      await readerThemeRepository.saveReaderTheme(event.readerTheme);
      emit(ReaderThemeState(event.readerTheme.copy()));
    });
  }
  ReaderThemeConfig get currentTheme => state.readerTheme;
}

@immutable
class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

@immutable
class ReaderThemeEvent extends ThemeEvent {
  final ReaderThemeConfig readerTheme;

  const ReaderThemeEvent(this.readerTheme);

  @override
  List<Object> get props => [readerTheme];
}

@immutable
class ReaderThemeInitEvent extends ThemeEvent {
  @override
  List<Object> get props => [];
}

@immutable
class ReaderThemeState extends Equatable {
  final ReaderThemeConfig readerTheme;

  const ReaderThemeState(this.readerTheme);

  @override
  List<Object> get props => [readerTheme];
}
