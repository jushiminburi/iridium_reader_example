// Copyright (c) 2022 Mantano. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mno_navigator/epub.dart';
import 'package:mno_navigator/src/common/data/repository/view_setting_repository.dart';

class ViewerSettingsBloc
    extends Bloc<ViewerSettingsEvent, ViewerSettingsState> {
  ViewerSettingsBloc(EpubReaderState readerState)
      : super(ViewerSettingsState(
            ViewerSettings.defaultSettings(fontSize: readerState.fontSize))) {
    ViewsettingRepository viewsettingRepository = ViewsettingRepository();
    on<ViewerSettingInitEvent>((event, emit) async {
      final viewSettings = await viewsettingRepository.currentSettingConfig();
      emit(ViewerSettingsState(viewSettings ??
          ViewerSettings.defaultSettings(fontSize: readerState.fontSize)));
    });
    on<ScrollSnapShouldStopEvent>((event, emit) async {
      await viewsettingRepository.saveViewsetting(
          state.viewerSettings.setScrollSnapShouldStop(event.shouldStop));
      emit(ViewerSettingsState(
          state.viewerSettings.setScrollSnapShouldStop(event.shouldStop)));
    });
    on<IncrFontSizeEvent>((event, emit) async {
      await viewsettingRepository
          .saveViewsetting(state.viewerSettings.incrFontSize());
      emit(ViewerSettingsState(state.viewerSettings.incrFontSize()));
    });
    on<DecrFontSizeEvent>((event, emit) async {
      await viewsettingRepository
          .saveViewsetting(state.viewerSettings.decrFontSize());
      emit(ViewerSettingsState(state.viewerSettings.decrFontSize()));
    });
  }

  ViewerSettings get viewerSettings => state.viewerSettings;
}

@immutable
abstract class ViewerSettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ViewerSettingInitEvent extends ViewerSettingsEvent {
  @override
  String toString() => 'ViewerSettingInitEvent {}';
}

class ScrollSnapShouldStopEvent extends ViewerSettingsEvent {
  final bool shouldStop;

  ScrollSnapShouldStopEvent(this.shouldStop);

  @override
  String toString() => 'ScrollSnapShouldStopEvent {}';
}

class IncrFontSizeEvent extends ViewerSettingsEvent {
  @override
  String toString() => 'IncrFontSizeEvent {}';
}

class DecrFontSizeEvent extends ViewerSettingsEvent {
  @override
  String toString() => 'DecrFontSizeEvent {}';
}

@immutable
class ViewerSettingsState extends Equatable {
  final ViewerSettings viewerSettings;

  const ViewerSettingsState(this.viewerSettings);

  @override
  List<Object> get props => [viewerSettings];

  @override
  String toString() =>
      'ViewerSettingsState { viewerSettings: $viewerSettings }';
}
