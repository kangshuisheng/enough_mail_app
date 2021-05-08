import 'package:enough_mail_app/extensions/extensions.dart';
import 'package:enough_mail_app/models/models.dart';
import 'package:enough_mail_app/services/i18n_service.dart';
import 'package:enough_mail_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locator.dart';
import '../routes.dart';

class ExtensionActionTile extends StatelessWidget {
  final AppExtensionActionDescription actionDescription;
  const ExtensionActionTile({Key key, @required this.actionDescription})
      : super(key: key);

  static Widget buildSideMenuForAccount(
      BuildContext context, Account currentAccount) {
    if (currentAccount.isVirtual) {
      return Container();
    }
    final actions = currentAccount.account.appExtensionsAccountSideMenu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildActionWidgets(context, actions),
    );
  }

  static List<Widget> buildActionWidgets(
      BuildContext context, List<AppExtensionActionDescription> actions,
      {bool withDivider = true}) {
    if (actions.isEmpty) {
      return [];
    }
    final widgets = <Widget>[];
    if (withDivider) {
      widgets.add(Divider());
    }
    for (final action in actions) {
      widgets.add(ExtensionActionTile(actionDescription: action));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = locator<I18nService>().locale.languageCode;

    return ListTile(
      leading: actionDescription.icon == null
          ? null
          : Image.network(
              actionDescription.icon,
              height: 24,
              width: 24,
            ),
      title: Text(actionDescription.getLabel(languageCode)),
      onTap: () {
        final url = actionDescription.action.url;
        switch (actionDescription.action.mechanism) {
          case AppExtensionActionMechanism.inapp:
            final navService = locator<NavigationService>();
            navService.pop();
            navService.push(
              Routes.webview,
              arguments: WebViewConfiguration(
                actionDescription.getLabel(languageCode),
                Uri.parse(url),
              ),
            );
            break;
          case AppExtensionActionMechanism.external:
            launch(url);
            break;
        }
      },
    );
  }
}
