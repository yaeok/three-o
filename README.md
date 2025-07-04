# three_o (AI 上司相談アプリ)

あなただけの AI 上司を作成し、気軽にキャリア相談ができる Flutter アプリケーションです。

## 概要

このアプリでは、ユーザーが複数の「AI 上司」を定義できます。それぞれの AI 上司には、名前、役職（メンター、部長など）、性格（厳しい、優しい、論理的など）、専門分野（IT 業界、マーケティング、Web3 など）を自由に設定することが可能です。これにより、ユーザーは自分の状況や相談内容に合わせて、最適な AI 上司とチャット形式で対話できます。

例えば、「厳しいけれど的確なアドバイスをくれる IT 部長」や「親身に話を聞いてくれる同業界の先輩」といった、多彩なペルソナを持つ AI との壁打ちを通じて、キャリアに関する悩みや思考の整理をサポートします。

バックエンドには Firebase (Authentication, Firestore) を採用し、ユーザー認証やデータ永続化を安全に実現しています。AI チャット機能には、Google の最新モデルである Gemini API を利用し、自然で質の高い対話体験を提供します。

## 技術スタック

このプロジェクトで採用している主要な技術は以下の通りです。

- **フレームワーク**: Flutter

  - クロスプラットフォーム開発の生産性と、宣言的な UI 構築による開発体験の良さから採用しています。

- **UI**: Material 3

  - モダンで表現力豊かなデザインシステム。少ない労力で高品質な UI を構築するために活用しています。

- **状態管理**: Riverpod

  - コンパイルセーフで宣言的な状態管理を実現できるライブラリ。依存性の注入(DI)もシンプルに記述でき、テストのしやすさとスケーラビリティを確保しています。

- **ルーティング**: GoRouter

  - 宣言的なルーティングで、複雑な画面遷移やディープリンク対応を容易にするために採用。URL ベースの遷移は Web 版での展開も見据えています。

- **バックエンド (BaaS)**: Firebase (Authentication, Cloud Firestore)

  - サーバーレスで迅速な開発を実現。Authentication による堅牢なユーザー認証と、NoSQL データベースである Firestore による柔軟なデータ管理を行っています。

- **AI**: Google Gemini API

  - 高度な文脈理解能力と自然な対話生成能力を持つ LLM。システムプロンプトによる AI のペルソナ設定の自由度が高い点を評価し、採用しています。

- **その他**:
  - **Freezed**: イミュータブル（不変）なモデルクラスを安全かつ簡潔に定義するために使用。
  - **JsonSerializable**: モデルクラスと JSON の相互変換を自動化し、Firestore とのデータ連携を容易にします。
  - **Google Fonts**: アプリ全体のタイポグラフィに一貫性を持たせ、デザイン品質を向上させるために導入。

## プロジェクト構成

このプロジェクトは、クリーンアーキテクチャの考え方を参考に、以下の 4 つのレイヤーに分割されています。

- `lib/domain`: アプリケーションの核となるビジネスロジック。モデル（`Model`）と、その操作を定義するインターフェース（`Repository`）が含まれます。
- `lib/application`: `domain`層と`presentation`層を繋ぐユースケース（`Usecase`）を定義。具体的なビジネスフローを記述します。
- `lib/infrastructure`: `domain`層で定義された`Repository`の具体的な実装。Firebase や Gemini API など、外部サービスとの通信ロジックはここに集約されます。
- `lib/presentation`: UI（`Page`, `Widget`）と、UI の状態を管理する`Provider`が含まれます。ユーザーとのインタラクションを担当します。

## 開発環境のセットアップ

### 1. Flutter SDK の準備

Flutter 公式サイトの案内に従い、お使いの OS に合わせた開発環境を構築してください。チームでの開発や複数プロジェクトを管理する場合は、Flutter のバージョン管理ツール（例: `FVM`）の導入を推奨します。

- [Flutter - Get Started](https://docs.flutter.dev/get-started/install)

### 2. プロジェクトのクローンと依存パッケージの導入

```bash
# プロジェクトをクローン
git clone <repository_url>
cd three_o

# 依存パッケージをインストール
# pubspec.yamlに記述されたライブラリをダウンロード・設定します
flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

```
