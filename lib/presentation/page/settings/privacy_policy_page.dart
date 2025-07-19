import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('プライバシーポリシー')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        // IMPORTANT: 以下の内容は一般的なテンプレートです。
        // リリース前に必ず弁護士などの専門家による確認を受けてください。
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('プライバシーポリシー', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              '八重尾　紘平（以下、「当方」といいます。）は、本アプリケーション「three_o」（以下、「本サービス」といいます。）における、ユーザーの個人情報の取扱いについて、以下のとおりプライバシーポリシー（以下、「本ポリシー」といいます。）を定めます。',
            ),
            const SizedBox(height: 24),
            Text('第1条（収集する個人情報）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '本サービスにおいて、当方は以下の情報を収集します。\n- メールアドレス（アカウント登録時）\n- パスワード（ハッシュ化された状態で保存）\n- ユーザープロフィール情報（氏名、業種、年齢、性別など、ユーザーが任意で入力する情報）\n- AI上司設定情報（ユーザーが作成したAI上司の名前、役職、性格、専門分野など）\n- チャット履歴（ユーザーとAIとの対話内容）\n- 利用状況データ（メッセージ送信回数、最終利用日時など）',
            ),
            const SizedBox(height: 24),
            Text('第2条（個人情報の利用目的）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '当方は、収集した情報を以下の目的で利用します。\n- 本サービスの提供、運営、ユーザー認証のため\n- ユーザーごとにパーソナライズされたAI応答を生成するため\n- 本サービスの改善、新機能の開発のため\n- ユーザーからのお問い合わせに対応するため\n- その他、上記の利用目的に付随する目的のため',
            ),
            const SizedBox(height: 24),
            Text('第3条（第三者への情報提供）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '当方は、ユーザーの同意を得ずに、個人情報を第三者に提供することはありません。ただし、法令に基づく場合や、人の生命、身体または財産の保護のために必要がある場合はこの限りではありません。本サービスは、以下の第三者サービスを利用しており、サービスの提供に必要な範囲で情報が送信されることがあります。\n\n1. Google Firebase (Authentication, Cloud Firestore)\n  - 提供者: Google LLC\n  - 利用目的: ユーザー認証、データベース機能の提供\n  - Googleのプライバシーポリシー: https://policies.google.com/privacy\n\n2. Google Gemini API\n  - 提供者: Google LLC\n  - 利用目的: ユーザーの入力に基づいたAI応答の生成。チャット履歴やAI上司設定が、応答生成のためにGoogleのサーバーへ送信されます。\n  - Google APIのプライバシーポリシー: Googleのポリシーに準じます。',
            ),
            const SizedBox(height: 24),
            Text('第4条（個人情報の管理）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '当方は、ユーザーの個人情報を正確かつ最新の状態に保ち、個人情報への不正アクセス・紛失・破損・改ざん・漏洩などを防止するため、セキュリティシステムの維持・管理体制の整備等の必要な措置を講じ、安全対策を実施し個人情報の厳重な管理を行います。',
            ),
            const SizedBox(height: 24),
            Text('第5条（ユーザーの権利）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'ユーザーは、本サービス内の機能を利用して、自身のプロフィール情報の照会・修正を行うことができます。アカウント全体の削除を希望する場合は、アプリ内の「アカウント削除」機能より申請を行うことができます。',
            ),
            const SizedBox(height: 24),
            Text('第6条（プライバシーポリシーの変更）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '本ポリシーの内容は、法令その他本ポリシーに別段の定めのある事項を除いて、ユーザーに通知することなく、変更することができるものとします。変更後のプライバシーポリシーは、本ウェブサイトに掲載したときから効力を生じるものとします。',
            ),
            const SizedBox(height: 24),
            Text('第7条（お問い合わせ窓口）', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              '本ポリシーに関するお問い合わせは、下記の窓口までお願いいたします。\n\n[あなたの連絡先メールアドレスなど]',
            ),
            const SizedBox(height: 32),
            const Text('2025年6月29日 制定'),
          ],
        ),
      ),
    );
  }
}
