import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdWidget extends StatefulWidget {
  const RewardedAdWidget({super.key});

  @override
  State<RewardedAdWidget> createState() {
    return _RewardedAdWidgetState();
  }
}

class _RewardedAdWidgetState extends State<RewardedAdWidget> {
  RewardedAd? _rewardedAd;

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
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
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
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Help me pay my bills by watching an ad'),
      trailing: IconButton(
        onPressed: () {
          loadAd();
          setState(() {
            _rewardedAd!.show(onUserEarnedReward: (adWithoutView, rewardItem) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Thank you for your support!'),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.favorite),
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
