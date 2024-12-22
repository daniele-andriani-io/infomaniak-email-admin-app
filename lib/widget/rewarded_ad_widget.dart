import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infomaniak_email_admin_app/provider/ads_watched.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RewardedAdWidget extends StatefulWidget {
  const RewardedAdWidget({super.key});

  @override
  State<RewardedAdWidget> createState() {
    return _RewardedAdWidgetState();
  }
}

class _RewardedAdWidgetState extends State<RewardedAdWidget> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  /// Loads a rewarded ad.
  void loadAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.heart_broken),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(AppLocalizations.of(context)!.rewards_error),
                      ],
                    ),
                  ),
                );
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.heart_broken),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(AppLocalizations.of(context)!.rewards_error),
                ],
              ),
            ),
          );
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.rewards_help),
      trailing: IconButton(
        onPressed: () {
          loadAd();
          setState(() {
            _rewardedAd!.show(onUserEarnedReward: (adWithoutView, rewardItem) {
              adsWatchedProvider.incrementNumberOfAdsWatched();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(adsWatchedProvider.getThanksPhrase(context)),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.favorite),
                    ],
                  ),
                ),
              );
            });
          });
        },
        icon: const Icon(
          Icons.monetization_on,
        ),
      ),
    );
  }
}
