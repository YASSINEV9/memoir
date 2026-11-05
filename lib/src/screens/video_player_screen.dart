import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:video_player/video_player.dart';

import '../archive/archive_item.dart';
import '../l10n.dart';
import '../media_actions.dart';

/// Plays a saved video inside Memoir, with buttons to open it in another app
/// or in Google Drive instead.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    required this.item,
    required this.onSave,
    super.key,
  });
  final ArchiveItem item;
  final Future<void> Function(ArchiveItem) onSave;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _video = VideoPlayerController.file(
    File(widget.item.localPath!),
  );
  bool _failed = false;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();
    _video.addListener(_refresh);
    _video.initialize().then((_) => _video.play()).catchError((Object _) {
      if (mounted) setState(() => _failed = true);
    });
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _video
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  static String _clock(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final value = _video.value;
    final item = widget.item;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.filename ?? l10n.video,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              DateFormat.MMMd().add_Hm().format(
                DateTime.fromMillisecondsSinceEpoch(item.createdAt),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.saveToGallery,
            onPressed: () => widget.onSave(item),
            icon: const Icon(Icons.download_rounded),
          ),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            onSelected: (value) {
              _video.pause();
              value == 'drive'
                  ? openInDrive(context, item)
                  : openWithOtherApp(context, item);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'app',
                child: ListTile(
                  leading: const Icon(Icons.open_in_new_rounded),
                  title: Text(l10n.openWith),
                ),
              ),
              if (item.driveId != null)
                PopupMenuItem(
                  value: 'drive',
                  child: ListTile(
                    leading: const Icon(Icons.add_to_drive_outlined),
                    title: Text(l10n.openInDrive),
                  ),
                ),
            ],
          ),
        ],
      ),
      // The player and its timeline run left to right in every language.
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: _failed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.videoLoadFailed,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => openWithOtherApp(context, item),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: Text(l10n.openWith),
                      ),
                    ],
                  ),
                ),
              )
            : !value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    setState(() => _controlsVisible = !_controlsVisible),
                child: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: value.aspectRatio,
                        child: VideoPlayer(_video),
                      ),
                    ),
                    if (_controlsVisible) ...[
                      Center(
                        child: IconButton.filled(
                          iconSize: 44,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: () =>
                              value.isPlaying ? _video.pause() : _video.play(),
                          icon: Icon(
                            value.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Row(
                              children: [
                                Text(
                                  _clock(value.position),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                  child: VideoProgressIndicator(
                                    _video,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  _clock(value.duration),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
