import 'package:admin_panel/data/model/promote.dart';
import 'package:flutter/material.dart';

class PromoteCard extends StatelessWidget {
  const PromoteCard({super.key, required this.promote});
  final Promote promote;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = promote.imageUrl.trim();

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IMAGE SECTION
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child:
                  imageUrl.startsWith('http')
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/default_promo.jpg',
                              fit: BoxFit.cover,
                            ),
                      )
                      : Image.asset(
                        imageUrl.isNotEmpty
                            ? imageUrl
                            : 'assets/default_promo.jpg',
                        fit: BoxFit.cover,
                      ),
            ),
          ),

          // DETAILS SECTION
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promote.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  promote.description,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Chain: ${promote.chain}',
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PrintHandler() {
    print("PromoteCard for ${promote.name} initialized.");
  }
}
