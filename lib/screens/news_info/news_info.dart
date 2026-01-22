import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_news_new/common/colors.dart';
import 'package:flutter_news_new/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class NewsInfo extends StatelessWidget {
  final News news;

  const NewsInfo({
    super.key,
    required this.news,
  });

  // Edited by Thida - improved safe version
  String cleanContent(String? content) {
    if (content == null || content.isEmpty) {
      return 'No detailed content available for this article.';
    }
    // Remove "[+xxx chars]" from content if exists
    return content.split('[+').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                news.urlToImage ?? 'https://via.placeholder.com/400x200',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// TITLE
            Text(
              news.title ?? 'No title available',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 10),

            /// AUTHOR + DATE
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    news.author ?? 'Unknown author',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  news.publishedAt != null && news.publishedAt!.isNotEmpty
                      ? Jiffy.parse(news.publishedAt!).fromNow()
                      : 'Unknown date',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// CONTENT
            Text(
              cleanContent(news.content),
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),

            const Divider(height: 32),

            /// BUTTONS
            if (news.url != null && news.url!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Slightly changed button style and added Thida marker
                  ElevatedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Read Full Article 🔹'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // using your app color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final uri = Uri.tryParse(news.url!);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share Article 🔹'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    onPressed: () {
                      Share.share(
                        '${news.title}\n\nRead more:\n${news.url}',
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
