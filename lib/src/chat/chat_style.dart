import 'package:flutter/material.dart';

enum TailSide { none, bottom, top }

/// Visual theme of a chat screen, modelled on the messaging app a collection
/// archives. Everything is drawn in code so no image assets are bundled.
class ChatStyle {
  const ChatStyle({
    required this.appBar,
    required this.appBarForeground,
    required this.avatar,
    required this.avatarIcon,
    required this.background,
    required this.outgoing,
    required this.outgoingText,
    required this.meta,
    required this.link,
    required this.radius,
    required this.tail,
    required this.composerBar,
    required this.composerPill,
    required this.composerHint,
    required this.accent,
    required this.dateChip,
    required this.dateChipText,
    this.outgoingGradient,
    this.checks,
    this.doodle,
    this.separateSendButton = false,
    this.composerOutlined = false,
    this.hint = 'Message',
  });

  final Color appBar;
  final Color appBarForeground;
  final Color avatar;
  final IconData avatarIcon;

  /// One colour for a flat background, several for a vertical gradient.
  final List<Color> background;
  final Color? doodle;

  final Color outgoing;
  final Gradient? outgoingGradient;
  final Color outgoingText;
  final Color meta;
  final Color? checks;
  final Color link;
  final double radius;
  final TailSide tail;

  final Color composerBar;
  final Color composerPill;
  final Color composerHint;
  final bool composerOutlined;
  final bool separateSendButton;
  final Color accent;
  final String hint;

  final Color dateChip;
  final Color dateChipText;

  static ChatStyle of(String collectionId, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (collectionId) {
      'telegram' => dark ? _telegramDark : _telegram,
      'whatsapp' => dark ? _whatsappDark : _whatsapp,
      'facebook' => dark ? _messengerDark : _messenger,
      'instagram' => dark ? _instagramDark : _instagram,
      _ => dark ? _personalDark : _personal,
    };
  }

  static const _telegram = ChatStyle(
    appBar: Color(0xff517da2),
    appBarForeground: Colors.white,
    avatar: Color(0xff65aadd),
    avatarIcon: Icons.bookmark_rounded,
    background: [Color(0xffd5e4b0), Color(0xffa3c9a2), Color(0xff8bbaa9)],
    doodle: Color(0x1a2e5a3c),
    outgoing: Color(0xffeffedd),
    outgoingText: Color(0xff000000),
    meta: Color(0xff5dae5a),
    checks: Color(0xff5dae5a),
    link: Color(0xff2a8bd1),
    radius: 17,
    tail: TailSide.bottom,
    composerBar: Colors.white,
    composerPill: Colors.white,
    composerHint: Color(0xff9aa3ab),
    accent: Color(0xff3e9ade),
    dateChip: Color(0x55384a3e),
    dateChipText: Colors.white,
  );

  static const _telegramDark = ChatStyle(
    appBar: Color(0xff212d3b),
    appBarForeground: Colors.white,
    avatar: Color(0xff5288c1),
    avatarIcon: Icons.bookmark_rounded,
    background: [Color(0xff0e1621)],
    doodle: Color(0x0fffffff),
    outgoing: Color(0xff2b5278),
    outgoingText: Colors.white,
    meta: Color(0xff7da8d3),
    checks: Color(0xff7da8d3),
    link: Color(0xff71baf2),
    radius: 17,
    tail: TailSide.bottom,
    composerBar: Color(0xff17212b),
    composerPill: Color(0xff17212b),
    composerHint: Color(0xff6c7883),
    accent: Color(0xff5eb5f7),
    dateChip: Color(0x661e2c3a),
    dateChipText: Colors.white,
  );

  static const _whatsapp = ChatStyle(
    appBar: Color(0xff008069),
    appBarForeground: Colors.white,
    avatar: Color(0xff25d366),
    avatarIcon: Icons.chat_rounded,
    background: [Color(0xffefeae2)],
    doodle: Color(0x14705c45),
    outgoing: Color(0xffd9fdd3),
    outgoingText: Color(0xff111b21),
    meta: Color(0xff667781),
    checks: Color(0xff53bdeb),
    link: Color(0xff027eb5),
    radius: 8,
    tail: TailSide.top,
    composerBar: Colors.transparent,
    composerPill: Colors.white,
    composerHint: Color(0xff8696a0),
    accent: Color(0xff00a884),
    separateSendButton: true,
    dateChip: Colors.white,
    dateChipText: Color(0xff54656f),
  );

  static const _whatsappDark = ChatStyle(
    appBar: Color(0xff1f2c34),
    appBarForeground: Color(0xffe9edef),
    avatar: Color(0xff25d366),
    avatarIcon: Icons.chat_rounded,
    background: [Color(0xff0b141a)],
    doodle: Color(0x0cffffff),
    outgoing: Color(0xff005c4b),
    outgoingText: Color(0xffe9edef),
    meta: Color(0x99e9edef),
    checks: Color(0xff53bdeb),
    link: Color(0xff53bdeb),
    radius: 8,
    tail: TailSide.top,
    composerBar: Colors.transparent,
    composerPill: Color(0xff1f2c34),
    composerHint: Color(0xff8696a0),
    accent: Color(0xff00a884),
    separateSendButton: true,
    dateChip: Color(0xff182229),
    dateChipText: Color(0xff8696a0),
  );

  static const _messenger = ChatStyle(
    appBar: Colors.white,
    appBarForeground: Color(0xff050505),
    avatar: Color(0xff0866ff),
    avatarIcon: Icons.forum_rounded,
    background: [Colors.white],
    outgoing: Color(0xff0866ff),
    outgoingGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffa033ff), Color(0xff0866ff)],
    ),
    outgoingText: Colors.white,
    meta: Color(0xccffffff),
    link: Colors.white,
    radius: 18,
    tail: TailSide.none,
    composerBar: Colors.white,
    composerPill: Color(0xfff0f2f5),
    composerHint: Color(0xff65676b),
    accent: Color(0xff0866ff),
    hint: 'Aa',
    dateChip: Colors.transparent,
    dateChipText: Color(0xff65676b),
  );

  static const _messengerDark = ChatStyle(
    appBar: Color(0xff000000),
    appBarForeground: Color(0xffe4e6eb),
    avatar: Color(0xff0866ff),
    avatarIcon: Icons.forum_rounded,
    background: [Color(0xff000000)],
    outgoing: Color(0xff0866ff),
    outgoingGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffa033ff), Color(0xff0866ff)],
    ),
    outgoingText: Colors.white,
    meta: Color(0xccffffff),
    link: Colors.white,
    radius: 18,
    tail: TailSide.none,
    composerBar: Color(0xff000000),
    composerPill: Color(0xff242526),
    composerHint: Color(0xffb0b3b8),
    accent: Color(0xff0866ff),
    hint: 'Aa',
    dateChip: Colors.transparent,
    dateChipText: Color(0xffb0b3b8),
  );

  static const _instagram = ChatStyle(
    appBar: Colors.white,
    appBarForeground: Color(0xff000000),
    avatar: Color(0xffd62976),
    avatarIcon: Icons.camera_alt_outlined,
    background: [Colors.white],
    outgoing: Color(0xff7c3aed),
    outgoingGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff6d28d9), Color(0xffa21caf), Color(0xffdb2777)],
    ),
    outgoingText: Colors.white,
    meta: Color(0xccffffff),
    link: Colors.white,
    radius: 22,
    tail: TailSide.none,
    composerBar: Colors.white,
    composerPill: Colors.white,
    composerHint: Color(0xff737373),
    composerOutlined: true,
    accent: Color(0xff0095f6),
    hint: 'Message...',
    dateChip: Colors.transparent,
    dateChipText: Color(0xff737373),
  );

  static const _instagramDark = ChatStyle(
    appBar: Color(0xff000000),
    appBarForeground: Colors.white,
    avatar: Color(0xffd62976),
    avatarIcon: Icons.camera_alt_outlined,
    background: [Color(0xff000000)],
    outgoing: Color(0xff7c3aed),
    outgoingGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff6d28d9), Color(0xffa21caf), Color(0xffdb2777)],
    ),
    outgoingText: Colors.white,
    meta: Color(0xccffffff),
    link: Colors.white,
    radius: 22,
    tail: TailSide.none,
    composerBar: Color(0xff000000),
    composerPill: Color(0xff262626),
    composerHint: Color(0xffa8a8a8),
    accent: Color(0xff0095f6),
    hint: 'Message...',
    dateChip: Colors.transparent,
    dateChipText: Color(0xffa8a8a8),
  );

  static const _personal = ChatStyle(
    appBar: Color(0xfff3f6fa),
    appBarForeground: Color(0xff10202c),
    avatar: Color(0xff16b8a6),
    avatarIcon: Icons.lock_outline_rounded,
    background: [Color(0xfff3f6fa)],
    doodle: Color(0x13527f72),
    outgoing: Color(0xffd9fdd3),
    outgoingText: Color(0xff10202c),
    meta: Color(0xff5f7a72),
    link: Color(0xff118577),
    radius: 18,
    tail: TailSide.none,
    composerBar: Colors.white,
    composerPill: Color(0xfff0f3f6),
    composerHint: Color(0xff7c8a94),
    accent: Color(0xff16b8a6),
    dateChip: Color(0xffe2e9ee),
    dateChipText: Color(0xff4b5c66),
  );

  static const _personalDark = ChatStyle(
    appBar: Color(0xff0b1421),
    appBarForeground: Colors.white,
    avatar: Color(0xff16b8a6),
    avatarIcon: Icons.lock_outline_rounded,
    background: [Color(0xff0b1421)],
    doodle: Color(0x0eb8d7ce),
    outgoing: Color(0xff173a43),
    outgoingText: Colors.white,
    meta: Color(0xff8fb5ac),
    link: Color(0xff5fd8c8),
    radius: 18,
    tail: TailSide.none,
    composerBar: Color(0xff111b2a),
    composerPill: Color(0xff1a2636),
    composerHint: Color(0xff7c8a94),
    accent: Color(0xff16b8a6),
    dateChip: Color(0xff1a2636),
    dateChipText: Color(0xffb7c4cc),
  );
}

/// Chat wallpaper: a flat colour or gradient with an optional doodle pattern.
class ChatWallpaper extends StatelessWidget {
  const ChatWallpaper({required this.style, super.key});
  final ChatStyle style;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: style.background.first,
      gradient: style.background.length > 1
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: style.background,
            )
          : null,
    ),
    child: style.doodle == null
        ? const SizedBox.expand()
        : CustomPaint(
            painter: _DoodlePainter(style.doodle!),
            child: const SizedBox.expand(),
          ),
  );
}

class _DoodlePainter extends CustomPainter {
  const _DoodlePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    const cell = 64.0;
    for (var row = 0; row * cell < size.height + cell; row++) {
      for (var col = 0; col * cell < size.width + cell; col++) {
        final c = Offset(col * cell + (row.isEven ? 16 : 48), row * cell + 20);
        switch ((row * 3 + col) % 6) {
          case 0: // heart
            final path = Path()
              ..moveTo(c.dx, c.dy + 7)
              ..cubicTo(
                c.dx - 12,
                c.dy - 2,
                c.dx - 5,
                c.dy - 11,
                c.dx,
                c.dy - 4,
              )
              ..cubicTo(
                c.dx + 5,
                c.dy - 11,
                c.dx + 12,
                c.dy - 2,
                c.dx,
                c.dy + 7,
              );
            canvas.drawPath(path, paint);
          case 1: // star
            final path = Path();
            for (var i = 0; i < 5; i++) {
              final outer = Offset.fromDirection(-1.5708 + i * 1.2566, 8) + c;
              final inner =
                  Offset.fromDirection(-1.5708 + i * 1.2566 + 0.6283, 3.5) + c;
              i == 0
                  ? path.moveTo(outer.dx, outer.dy)
                  : path.lineTo(outer.dx, outer.dy);
              path.lineTo(inner.dx, inner.dy);
            }
            canvas.drawPath(path..close(), paint);
          case 2: // speech bubble
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromCenter(center: c, width: 18, height: 13),
                const Radius.circular(5),
              ),
              paint,
            );
            canvas.drawLine(
              c + const Offset(-4, 6),
              c + const Offset(-7, 11),
              paint,
            );
          case 3: // paper plane
            final path = Path()
              ..moveTo(c.dx - 9, c.dy)
              ..lineTo(c.dx + 9, c.dy - 7)
              ..lineTo(c.dx + 3, c.dy + 8)
              ..lineTo(c.dx - 1, c.dy + 2)
              ..close();
            canvas.drawPath(path, paint);
          case 4: // music note
            canvas.drawCircle(c + const Offset(-3, 6), 3, paint);
            canvas.drawLine(
              c + const Offset(0, 6),
              c + const Offset(0, -8),
              paint,
            );
            canvas.drawLine(
              c + const Offset(0, -8),
              c + const Offset(6, -5),
              paint,
            );
          default: // smile
            canvas.drawCircle(c, 8, paint);
            canvas.drawArc(
              Rect.fromCenter(
                center: c + const Offset(0, 1),
                width: 9,
                height: 7,
              ),
              0.3,
              2.5,
              false,
              paint,
            );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DoodlePainter oldDelegate) =>
      oldDelegate.color != color;
}
