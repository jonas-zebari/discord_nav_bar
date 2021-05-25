import 'package:discord_nav_bar/theme.dart';
import 'package:flutter/material.dart';

class ServerNavigationRail extends StatefulWidget {
  const ServerNavigationRail({
    Key? key,
    required this.items,
    required this.selectedIndex,
    this.onChanged,
  }) : super(key: key);

  final List<ServerItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  _ServerNavigationRailState createState() => _ServerNavigationRailState();
}

class _ServerNavigationRailState extends State<ServerNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: DiscordTheme.background2,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 4),
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _DiscordServerItemWidget(
              item: widget.items[i],
              selected: widget.selectedIndex == i,
              onPressed: () => widget.onChanged?.call(i),
            ),
        ],
      ),
    );
  }
}

class _DiscordServerItemWidget extends StatefulWidget {
  const _DiscordServerItemWidget({
    Key? key,
    required this.item,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final ServerItem item;
  final bool selected;
  final VoidCallback onPressed;

  @override
  _DiscordServerItemWidgetState createState() =>
      _DiscordServerItemWidgetState();
}

class _DiscordServerItemWidgetState extends State<_DiscordServerItemWidget>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 75));
  late final Animation<double> _opacity = Tween(begin: 0.5, end: 1.0)
      .chain(CurveTween(curve: Curves.easeIn))
      .animate(_controller);
  late final Animation<double> _scale = Tween(begin: 0.8, end: 1.0)
      .chain(CurveTween(curve: Curves.easeOutBack))
      .animate(_controller);

  late OverlayEntry _overlayEntry;
  var _isHovering = false;
  var _isMouseDown = false;

  double get _barHeight {
    if (widget.selected) {
      return 40;
    } else if (_isHovering) {
      return 20;
    } else {
      return 0;
    }
  }

  bool get _showBar => widget.selected || _isHovering;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOut,
          height: _barHeight,
          width: _showBar ? 4 : 0,
          decoration: BoxDecoration(
            color: _showBar ? DiscordTheme.white : Colors.transparent,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.onPressed,
          onTapDown: (_) => setState(() => _isMouseDown = true),
          onTapUp: (_) => setState(() => _isMouseDown = false),
          child: MouseRegion(
            onEnter: _onEnter,
            onExit: _onExit,
            child: Transform.translate(
              offset: _isMouseDown ? Offset(0.0, 1.0) : Offset.zero,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeOut,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.item.imageUrl == null
                      ? widget.item.backgroundColor
                      : null,
                  image: widget.item.imageUrl != null
                      ? DecorationImage(
                          image: AssetImage(widget.item.imageUrl!),
                          fit: BoxFit.fill,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(_showBar ? 16 : 32),
                ),
                child: AspectRatio(aspectRatio: 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onEnter(_) {
    setState(() => _isHovering = true);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final left = size.width + 8;
    final top = position.dy + 8;
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        left: left,
        top: top,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: child,
              ),
            );
          },
          child: Row(
            children: [
              CustomPaint(
                size: Size(4, 10),
                painter: _TrianglePainter(),
              ),
              Material(
                elevation: 16,
                shadowColor: DiscordTheme.shadow,
                color: DiscordTheme.background1,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
    Overlay.of(context)?.insert(_overlayEntry);
    _controller.forward();
  }

  void _onExit(_) {
    setState(() => _isHovering = false);
    _overlayEntry.remove();
    _controller.reset();
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = DiscordTheme.background1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ServerItem {
  const ServerItem({
    required this.name,
    this.backgroundColor = DiscordTheme.primary,
    this.imageUrl,
  });

  final String name;
  final Color backgroundColor;
  final String? imageUrl;
}
