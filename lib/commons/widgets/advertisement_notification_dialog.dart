import 'package:air_bnb_clone/data/models/realm_models/notification/notification.dart'
    as realm_model;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Centered, dark-elevated advertisement dialog (used by guest + host home shells).
class AdvertisementNotificationDialog {
  /// Highlighted card surface on near-black [ColorScheme.surface]; reads well on black themes.
  static const Color _kDialogSurface = Color(0xFF1C1C1E);

  static Future<void> show(
    BuildContext context, {
    required realm_model.Notification notification,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Dialog(
          backgroundColor: _kDialogSurface,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                top: 16,
                end: 16,
                bottom: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: (notification.imageUrl ?? '').isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: notification.imageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => ColoredBox(
                                color: scheme.onSurface.withValues(alpha: 0.06),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 48,
                                  color: scheme.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            )
                          : ColoredBox(
                              color: scheme.onSurface.withValues(alpha: 0.06),
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: scheme.onSurface.withValues(alpha: 0.35),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notification.title ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.body ?? '',
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'ProximaNova',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: scheme.onSurface.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
