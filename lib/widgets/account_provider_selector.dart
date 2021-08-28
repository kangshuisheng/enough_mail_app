import 'package:enough_mail_app/locator.dart';
import 'package:enough_mail_app/services/providers.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountProviderSelector extends StatelessWidget {
  final void Function(Provider? provider) onSelected;
  const AccountProviderSelector({Key? key, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final providers = locator<ProviderService>().providers;

    return ListView.separated(
        itemBuilder: (context, index) {
          if (index < providers.length) {
            final provider = providers[index];
            return Center(
              child: PlatformTextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/providers/${provider.key}.png',
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stacktrace) => Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: PlatformText(provider.displayName ?? '<unknown>'),
                    ),
                  ],
                ),
                onPressed: () => onSelected(provider),
              ),
            );
          } else {
            return Center(
              child: PlatformTextButton(
                child: PlatformText(localizations.accountProviderCustom),
                onPressed: () => onSelected(null),
              ),
            );
          }
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: providers.length + 1);
  }
}
