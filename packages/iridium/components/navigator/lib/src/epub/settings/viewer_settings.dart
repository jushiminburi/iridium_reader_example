// Copyright (c) 2022 Mantano. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class ViewerSettings {
  static const int minFontSize = 50; // in %
  static const int maxFontSize = 300; // in %
  final SyntheticSpreadMode syntheticSpreadMode;
  final ScrollMode scrollMode;
  int fontSize;
  final int columnGap;
  bool scrollSnapShouldStop = true;

  // If true, column gap will not be part of JSON conversion
  bool hasNoStyle = false;

  ViewerSettings(this.syntheticSpreadMode, this.scrollMode, this.fontSize,
      this.columnGap, this.scrollSnapShouldStop);

  factory ViewerSettings.defaultSettings(
          {int fontSize = 100, bool scrollSnapShouldStop = true}) =>
      ViewerSettings(SyntheticSpreadMode.single, ScrollMode.auto, fontSize, 0,
          scrollSnapShouldStop);

  ViewerSettings setScrollSnapShouldStop(bool shouldStop) => ViewerSettings(
      this.syntheticSpreadMode,
      this.scrollMode,
      this.fontSize,
      this.columnGap,
      shouldStop);

  ViewerSettings incrFontSize({int delta = 10}) {
    int newFontSize = fontSize + delta;
    newFontSize = newFontSize.clamp(minFontSize, maxFontSize);
    return ViewerSettings(this.syntheticSpreadMode, this.scrollMode,
        newFontSize, this.columnGap, this.scrollSnapShouldStop);
  }

  ViewerSettings decrFontSize({int delta = 10}) {
    int newFontSize = fontSize - delta;
    newFontSize = newFontSize.clamp(minFontSize, maxFontSize);
    return ViewerSettings(this.syntheticSpreadMode, this.scrollMode,
        newFontSize, this.columnGap, this.scrollSnapShouldStop);
  }

  bool get scrollViewDoc => scrollMode == ScrollMode.document;

  Map<String, dynamic> toJson(ViewerSettings settings) => {
        "syntheticSpread": settings.syntheticSpreadMode,
        "scroll": settings.scrollMode.name,
        "enableGPUHardwareAccelerationCSS3D": false,
        "fontSize": settings.fontSize,
        "columnGap": settings.columnGap,
        "--RS__scroll-snap-stop": settings.scrollSnapShouldStop,
      };

  factory ViewerSettings.fromJson(Map<String, dynamic> json) => ViewerSettings(
      json["syntheticSpread"] == "auto"
          ? SyntheticSpreadMode.auto
          : json["syntheticSpread"] == "double"
              ? SyntheticSpreadMode.double
              : SyntheticSpreadMode.single,
      json["scroll"] == "auto"
          ? ScrollMode.auto
          : json["scroll"] == "scroll-doc"
              ? ScrollMode.document
              : json["scroll-continuous"]
                  ? ScrollMode.continuous
                  : ScrollMode.continuousHorizontal,
      json["enableGPUHardwareAccelerationCSS3D"],
      json["columnGap"],
      json["--RS__scroll-snap-stop"]);

  String get _syntheticSpread {
    String syntheticSpread = "";
    switch (syntheticSpreadMode) {
      case SyntheticSpreadMode.auto:
        syntheticSpread = "auto";
        break;
      case SyntheticSpreadMode.double:
        syntheticSpread = "double";
        break;
      case SyntheticSpreadMode.single:
        syntheticSpread = "single";
        break;
    }
    return syntheticSpread;
  }

  String get _scroll {
    String scroll = "";
    switch (scrollMode) {
      case ScrollMode.auto:
        scroll = "auto";
        break;
      case ScrollMode.document:
        scroll = "scroll-doc";
        break;
      case ScrollMode.continuous:
        scroll = "scroll-continuous";
        break;
      case ScrollMode.continuousHorizontal:
        scroll = "scroll-continuous-horizontal";
        break;
    }
    return scroll;
  }

  @override
  String toString() =>
      'ViewerSettings{syntheticSpreadMode: $syntheticSpreadMode, scrollMode: $scrollMode, '
      'fontSize: $fontSize, columnGap: $columnGap, hasNoStyle: $hasNoStyle, --RS__scroll-snap-stop: $scrollSnapShouldStop}';
}

enum SyntheticSpreadMode { auto, double, single }

enum ScrollMode { auto, document, continuous, continuousHorizontal }
