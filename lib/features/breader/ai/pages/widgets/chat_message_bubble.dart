import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      // User style: Right aligned, beige bubble
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: const BoxDecoration(
              color: LivestColors.primaryLight, // f2eeea mapped color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(
                  4,
                ), // Slightly pointed bottom right
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              text,
              style: const TextStyle(
                color: LivestColors.textHeading,
                fontSize: LivestSizes.fontSizeSm,
              ),
            ),
          ),
        ),
      );
    } else {
      // Bot style: Left aligned, transparent/no bubble background, markdown support
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 32.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: MarkdownBody(
            data: text,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: LivestColors.textSecondary,
                fontSize: LivestSizes.fontSizeSm,
                height: 1.5,
              ),
              listBullet: const TextStyle(
                color: LivestColors.textSecondary,
                fontSize: LivestSizes.fontSizeSm,
              ),
              strong: const TextStyle(
                color: LivestColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              a: const TextStyle(
                color: LivestColors.primaryNormal,
                decoration: TextDecoration.underline,
              ),
            ),
            onTapLink: (text, href, title) async {
              if (href != null) {
                final url = Uri.parse(href);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              }
            },
          ),
        ),
      );
    }
  }
}
