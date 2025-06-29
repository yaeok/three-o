import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('利用規約')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        // IMPORTANT: 以下の内容は一般的なテンプレートです。
        // リリース前に必ず弁護士などの専門家による確認を受けてください。
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('three_o 利用規約', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              'この利用規約（以下、「本規約」といいます。）は、八重尾　紘平（以下、「当方」といいます。）が提供するアプリケーション「three_o」（以下、「本サービス」といいます。）の利用条件を定めるものです。本サービスをご利用になるユーザー（以下、「ユーザー」といいます。）は、本規約に同意の上、本サービスをご利用ください。',
            ),
            const SizedBox(height: 24),
            Text('第1条（適用）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('本規約は、ユーザーと当方との間の本サービスの利用に関わる一切の関係に適用されるものとします。'),
            const SizedBox(height: 24),
            Text('第2条（利用登録）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '1. 本サービスの利用を希望する者は、本規約に同意し、当方が定める方法によって利用登録を申請し、当方がこれを承認することによって、利用登録が完了するものとします。\n2. ユーザーは、自己の責任において、本サービスのユーザーIDおよびパスワードを適切に管理するものとします。',
            ),
            const SizedBox(height: 24),
            Text('第3条（禁止事項）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'ユーザーは、本サービスの利用にあたり、以下の行為をしてはなりません。\n- 法令または公序良俗に違反する行為\n- 犯罪行為に関連する行為\n- 本サービスの内容等、本サービスに含まれる著作権、商標権ほか知的財産権を侵害する行為\n- 当方、ほかのユーザー、またはその他第三者のサーバーまたはネットワークの機能を破壊したり、妨害したりする行為\n- 本サービスによって得られた情報を商業的に利用する行為\n- 当方のサービスの運営を妨害するおそれのある行為\n- 不正アクセスをし、またはこれを試みる行為\n- 他のユーザーに関する個人情報等を収集または蓄積する行為\n- 不正な目的を持って本サービスを利用する行為\n- その他、当方が不適切と判断する行為',
            ),
            const SizedBox(height: 24),
            Text('第4条（本サービスの提供の停止等）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '当方は、ユーザーに事前に通知することなく、本サービスの全部または一部の提供を停止または中断することができるものとします。',
            ),
            const SizedBox(height: 24),
            Text('第5条（免責事項）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '1. 本サービスが提供するAIによる応答は、情報の正確性、完全性、有用性を保証するものではありません。ユーザーは、自己の判断と責任において本サービスを利用するものとし、提供された情報に基づいて行ったいかなる行為の結果についても、当方は一切の責任を負いません。\n2. 当方は、本サービスに起因してユーザーに生じたあらゆる損害について一切の責任を負いません。',
            ),
            const SizedBox(height: 24),
            Text('第6条（利用規約の変更）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '当方は、必要と判断した場合には、ユーザーに通知することなくいつでも本規約を変更することができるものとします。',
            ),
            const SizedBox(height: 24),
            Text('第7条（準拠法・裁判管轄）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '本規約の解釈にあたっては、日本法を準拠法とします。本サービスに関して紛争が生じた場合には、当方の本店所在地を管轄する裁判所を専属的合意管轄とします。',
            ),
            const SizedBox(height: 32),
            const Text('2025年6月29日 制定'),
          ],
        ),
      ),
    );
  }
}
