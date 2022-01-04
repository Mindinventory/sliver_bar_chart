# sliver_bar_chart

<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/dart-website-deepskyblue.svg" alt="Dart Website"></a>
<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Android-deepskyblue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Web-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Mac-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Linux-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Windows-deepskyblue">
</a>
<a href=""><img src="https://app.codacy.com/project/badge/Grade/dc683c9cc61b499fa7cdbf54e4d9ff35"/></a>
<a href="https://github.com/Mindinventory/sliver_bar_chart/blob/master/LICENSE" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/github/license/Mindinventory/sliver_bar_chart"></a>
<a href="https://pub.dev/packages/sliver_bar_chart"><img src="https://img.shields.io/pub/v/sliver_bar_chart?color=as&label=sliver_bar_chart&logo=as1&logoColor=blue&style=social"></a>
<a href="https://github.com/Mindinventory/sliver_bar_chart"><img src="https://img.shields.io/github/stars/Mindinventory/sliver_bar_chart?style=social" alt="MIT License"></a>

A package that supports Bar Chart in a Flutter Sliver. This Package allow us to add Bar Chart in
Sliver and its set a Bar Chart as a Header on Slivers Scroll.

## Key Features

* easy way to add Bar Chart in a Sliver.
* used to set a Bar Chart as a Sliver Header.

# Preview

![sliver_bar_chart](https://github.com/Mindinventory/sliver_bar_chart/blob/master/assets/sliver_bar_chart.gif)

## Basic Usage

Import it to your project file

```
import 'package:sliver_bar_chart/sliver_bar_chart.dart';
```

And add it in its most basic form like it:

```
SliverBarChart(
  barWidget: BarChartWidget(
    minHeight: 100.0,
    maxHeight: 1000.0,
    barValues: [
      BarChartData(
        x: '2022',
        y: 500.0,
        barColor: Colors.blue,
      ),
    ],
    isScrolling: true,
  ),
);
```

### Required parameters of SliverBarChart
------------

| Parameter |  Description  |
| ------------ |  ------------ |
| BarChartWidget barWidget | Used to paint bar chart using custom painter |

### Optional parameters of SliverBarChart
------------

| Parameter |  Default | Description  |
| ------------ | ------------ | ------------ |
| bool restrain | false | Whether to stick the header to the start of the viewport once it has reached its minimum size |
| bool scrolling | - | Whether sliver is scrolling or not |
| List<double> heightArray | [50.0, 78.0, 90.0, 67.0, 36.0] | The array of height for generating the bars of the Bar Chart |
| double maxWidth | 75.0 | The maximum width dimensions of the sliver |
| double minHeight | 30.0 | The minimum height dimensions of the sliver |
| double maxHeight | 175.0 | The maximum height dimensions of the sliver |
| bool fluctuating | false | Whether the header should immediately grow again if the user reverses scroll direction |

### Required parameters of BarChartWidget
------------

| Parameter |  Description  |
| ------------ |  ------------ |
| double minHeight | The minimum height dimensions of the BarChartWidget |
| double maxHeight | The maximum height dimensions of the BarChartWidget |
| List<BarChartData> barValues | hold the list of bar chart data |
| bool isScrolling | Whether sliver is scrolling or not |

### Optional parameters of BarChartWidget
------------

| Parameter |  Default | Description  |
| ------------ | ------------ | ------------ |
| int yAxisIntervalCount | 5 | Used to set interval point on Y axis |
| double xAxisTextRotationAngle | 0.0 | Used to set X axis text on a rotation angle in case of larger text |

### Required parameters of BarChartData Model Class
------------

| Parameter |  Description  |
| ------------ |  ------------ |
| String x | a text that visible on Bar Chart X axis |
| double y | a value that visible on Bar Chart Y axis |

### Optional parameters of BarChartData Model Class
------------

| Parameter |  Default | Description  |
| ------------ | ------------ | ------------ |
| Color barColor | Colors.grey | used to set color of the bar |

### Guideline for contributors
------------

* Contribution towards our repository is always welcome, we request contributors to create a pull
  request for development.

### Guideline to report an issue/feature request
------------
It would be great for us if the reporter can share the below things to understand the root cause of
the issue.

* Library version
* Code snippet
* Logs if applicable
* Device specification like (Manufacturer, OS version, etc)
* Screenshot/video with steps to reproduce the issue
* Library used

LICENSE!
------------
**sliver_bar_chart**
is [MIT-licensed.](https://github.com/Mindinventory/sliver_bar_chart/blob/master/LICENSE)

Let us know!
------------
We’d be really happy if you send us links to your projects where you use our component. Just send an
email to sales@mindinventory.com And do let us know if you have any questions or suggestion
regarding our work.