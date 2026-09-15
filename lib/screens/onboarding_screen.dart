import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../widgets/circuit_background.dart';
import '../widgets/language_toggle.dart';

/// First-launch feature walkthrough: 4 pages describing what the app does.
///
/// Shown once, until the user taps "Get Started" / "Skip", which calls
/// [onComplete]. The completed flag is persisted by the caller.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.languageProvider,
    required this.onComplete,
  });

  final LanguageProvider languageProvider;
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const int _pageCount = 4;

  void _next() {
    if (_page == _pageCount - 1) {
      widget.onComplete();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  IconData _iconFor(String key) {
    return switch (key) {
      'wifi' => Icons.wifi_rounded,
      'speed' => Icons.speed_rounded,
      'monitor' => Icons.monitor_heart_rounded,
      'archive' => Icons.inventory_2_rounded,
      _ => Icons.network_check_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final List<_Slide> slides = <_Slide>[
      _Slide(l10n.onboarding_p1_title, l10n.onboarding_p1_desc,
          _iconFor(l10n.onboarding_p1_icon)),
      _Slide(l10n.onboarding_p2_title, l10n.onboarding_p2_desc,
          _iconFor(l10n.onboarding_p2_icon)),
      _Slide(l10n.onboarding_p3_title, l10n.onboarding_p3_desc,
          _iconFor(l10n.onboarding_p3_icon)),
      _Slide(l10n.onboarding_p4_title, l10n.onboarding_p4_desc,
          _iconFor(l10n.onboarding_p4_icon)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_page < _pageCount - 1)
                            TextButton(
                              onPressed: widget.onComplete,
                              child: Text(l10n.onboarding_skip),
                            ),
                          LanguageToggle(
                            languageProvider: widget.languageProvider,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pageCount,
                    onPageChanged: (int index) =>
                        setState(() => _page = index),
                    itemBuilder: (context, index) => _SlideView(slide: slides[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pageCount,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _page ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _page
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _next,
                          child: Text(
                            _page == _pageCount - 1
                                ? l10n.onboarding_done
                                : l10n.onboarding_next,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  const _Slide(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                width: 1.4,
              ),
            ),
            child: Icon(
              slide.icon,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 14),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}