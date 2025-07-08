import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

class ProgressSharingWidget extends StatefulWidget {
  final Widget child;
  final String shareText;
  final String shareTitle;

  const ProgressSharingWidget({
    super.key,
    required this.child,
    required this.shareText,
    required this.shareTitle,
  });

  @override
  State<ProgressSharingWidget> createState() => _ProgressSharingWidgetState();
}

class _ProgressSharingWidgetState extends State<ProgressSharingWidget> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Screenshot content
        Screenshot(
          controller: screenshotController,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                ],
              ),
            ),
            child: widget.child,
          ),
        ),

        const SizedBox(height: 16),

        // Share button
        GlassyContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.share_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share Your Progress',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Capture and share your achievement',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _isSharing
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _shareProgress,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 12),

              // Share options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    context,
                    icon: Icons.text_fields_outlined,
                    label: 'Text Only',
                    onTap: () => _shareText(),
                  ),
                  _buildShareOption(
                    context,
                    icon: Icons.image_outlined,
                    label: 'Screenshot',
                    onTap: () => _shareScreenshot(),
                  ),
                  _buildShareOption(
                    context,
                    icon: Icons.style_outlined,
                    label: 'Formatted',
                    onTap: () => _shareFormatted(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _isSharing ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareProgress() async {
    await _shareScreenshot();
  }

  Future<void> _shareText() async {
    if (_isSharing) return;

    try {
      setState(() {
        _isSharing = true;
      });

      await Share.share(widget.shareText, subject: widget.shareTitle);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to share text: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _shareScreenshot() async {
    if (_isSharing) return;

    try {
      setState(() {
        _isSharing = true;
      });

      // Capture the screenshot
      final Uint8List? image = await screenshotController.capture();

      if (image != null) {
        // Save to temporary file
        final tempDir = await getTemporaryDirectory();
        final file = await File(
          '${tempDir.path}/progress_screenshot.png',
        ).create();
        await file.writeAsBytes(image);

        // Share the file
        await Share.shareXFiles(
          [XFile(file.path)],
          text: widget.shareText,
          subject: widget.shareTitle,
        );
      } else {
        _showErrorSnackBar('Failed to capture screenshot');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to share screenshot: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _shareFormatted() async {
    if (_isSharing) return;

    try {
      setState(() {
        _isSharing = true;
      });

      // Create a formatted version with app branding
      final formattedText =
          '''
🌟 ${widget.shareTitle} 🌟

${widget.shareText}

✨ Shared from Sakinah - Your Islamic Companion App
#IslamicApp #Azkar #Spirituality #Progress
''';

      await Share.share(formattedText, subject: widget.shareTitle);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to share formatted text: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// A simpler version for quick sharing
class QuickShareButton extends StatelessWidget {
  final String shareText;
  final String shareTitle;
  final Widget? child;

  const QuickShareButton({
    super.key,
    required this.shareText,
    required this.shareTitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _quickShare(context),
      icon: child ?? const Icon(Icons.share_outlined),
      tooltip: 'Share Progress',
    );
  }

  Future<void> _quickShare(BuildContext context) async {
    try {
      await Share.share(shareText, subject: shareTitle);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
