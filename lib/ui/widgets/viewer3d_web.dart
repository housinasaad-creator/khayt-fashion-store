import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../../core/scroll.dart';
import '../theme.dart';

int _viewerCounter = 0;

String _hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// three.js knitwear viewer embedded as an iframe (assets/viewer/viewer.html).
/// Colour changes are pushed with postMessage so the garment re-tints live.
class Viewer3D extends StatefulWidget {
  final String style; // crew | oversize
  final Color color;
  const Viewer3D({super.key, required this.style, required this.color});

  @override
  State<Viewer3D> createState() => _Viewer3DState();
}

class _Viewer3DState extends State<Viewer3D> {
  late final String _viewType;
  web.HTMLIFrameElement? _iframe;
  bool _ready = false;
  late final JSFunction _listener;

  @override
  void initState() {
    super.initState();
    _viewType = 'khayt-viewer-${_viewerCounter++}';
    final startColor = widget.color;
    final style = widget.style;
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final f = web.HTMLIFrameElement()
        ..src = 'assets/assets/viewer/viewer.html?style=$style&color=${Uri.encodeComponent(_hex(startColor))}'
        ..setAttribute('title', '3D knitwear viewer');
      f.style
        ..border = 'none'
        ..width = '100%'
        ..height = '100%'
        ..background = 'transparent';
      _iframe = f;
      return f;
    });
    _listener = ((web.MessageEvent e) {
      final d = e.data.dartify();
      if (d is Map) {
        if (d['type'] == 'ready' && mounted) {
          setState(() => _ready = true);
        } else if (d['type'] == 'wheel') {
          final sc = activePageScroll;
          if (sc != null && sc.hasClients) {
            final dy = (d['dy'] as num).toDouble();
            sc.jumpTo((sc.offset + dy).clamp(0.0, sc.position.maxScrollExtent));
          }
        }
      }
    }).toJS;
    web.window.addEventListener('message', _listener);
  }

  @override
  void didUpdateWidget(covariant Viewer3D old) {
    super.didUpdateWidget(old);
    if (old.color != widget.color) {
      _iframe?.contentWindow?.postMessage({'type': 'color', 'value': _hex(widget.color)}.jsify(), '*'.toJS);
    }
  }

  @override
  void dispose() {
    web.window.removeEventListener('message', _listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      HtmlElementView(viewType: _viewType),
      if (!_ready)
        const IgnorePointer(
          child: Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2, color: KColors.muted))),
        ),
    ]);
  }
}
