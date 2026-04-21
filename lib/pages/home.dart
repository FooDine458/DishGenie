import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Offset _startLastOffset = Offset.zero;
  Offset _lastOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  double _lastScale = 1.0;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onLongPress: _onLongPress,
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onDoubleTap: _onDoubleTap,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _transformScaleAndTranslate(),
            _positionedStatusBar(context),
          ],
        ),
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    setState(() {
      _startLastOffset = details.focalPoint;
      _lastOffset = _currentOffset;
      _lastScale = _currentScale;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    double currentScale = _lastScale * details.scale;
    if (currentScale < 0.5) currentScale = 0.5;
    if (currentScale > 16.0) currentScale = 16.0;

    Offset offsetAdjustedForScale =
        (_startLastOffset - _lastOffset) / _lastScale;
    Offset currentOffset =
        details.focalPoint - (offsetAdjustedForScale * _currentScale);

    setState(() {
      _currentScale = currentScale;
      _currentOffset = currentOffset;
    });
  }

  void _onDoubleTap() {
    setState(() {
      double currentScale = _lastScale * 2.0;
      if (currentScale > 16.0) {
        _resetToDefaultValues();
      } else {
        _lastScale = currentScale;
        _currentScale = currentScale;
        _lastOffset = _currentOffset;
      }
    });
  }

  void _onLongPress() {
    setState(() {
      _resetToDefaultValues();
    });
  }

  void _resetToDefaultValues() {
    _startLastOffset = Offset.zero;
    _lastOffset = Offset.zero;
    _currentOffset = Offset.zero;
    _lastScale = 1.0;
    _currentScale = 1.0;
  }

  Transform _transformScaleAndTranslate() {
    return Transform.scale(
      scale: _currentScale,
      child: Transform.translate(
        offset: _currentOffset,
        child: Image.asset('assets/images/eagle.jpg'),
      ),
    );
  }

  Positioned _positionedStatusBar(BuildContext context) {
    return Positioned(
      top: 0.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.white54,
        height: 150.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Scale: ${_currentScale.toStringAsFixed(4)}'),
            Text('Offset: (${_currentOffset.dx.toStringAsFixed(1)}, ${_currentOffset.dy.toStringAsFixed(1)})'),
          ],
        ),
      ),
    );
  }
}