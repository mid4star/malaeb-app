import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../widgets/section_title.dart';
import '../widgets/movie_card.dart';

class EntertainmentScreen extends StatelessWidget {
  const EntertainmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            title: "المكتبة الترفيهية والوثائقية",
            sub: "أفلام ووثائقيات رياضية حصرية بجودة سينمائية فائقة",
            action: "",
          ),
          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final isTablet = constraints.maxWidth > 600;
              final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.movies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  final movie = provider.movies[index];
                  return MovieCardWidget(
                    movie: movie,
                    onPlay: () => provider.playStream(
                      title: movie.title,
                      url: movie.streamUrl,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
