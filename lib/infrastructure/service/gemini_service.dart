import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart' as app;

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
    : _model = GenerativeModel(
        // safetySettings を調整して、より柔軟な回答を許可
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        ],
        model: 'gemini-1.5-flash', // 利用するモデル
        apiKey: dotenv.env['GEMINI_API_KEY']!, // --dart-defineで設定したキーを取得
      );

  // AIからの応答を生成する
  Future<String> generateResponse({
    required Agent agent,
    required List<app.Message> history,
    required String userMessage,
  }) async {
    // 1. AIの役割を定義するシステムプロンプトを作成
    final systemPrompt =
        'あなたは「${agent.name}」という名前のAIアシスタントです。'
        '役職は「${agent.role}」です。'
        'あなたの性格と口調は以下の通りです。「${agent.personality}」'
        'あなたは以下の業界知識に特化しています。「${agent.industryInfo}」'
        'この設定に忠実に、ユーザーからの相談に親身に答えてください。';

    // 2. システムプロンプト、会話履歴、新しいメッセージを全て結合する
    final fullContent = [
      // システムプロンプトを会話の先頭に置く
      Content.system(systemPrompt),
      // 会話履歴を変換
      ...history.map(
        (msg) => Content(msg.sender == app.SenderRole.user ? 'user' : 'model', [
          TextPart(msg.text),
        ]),
      ),
      // 今回のユーザーメッセージを追加
      Content.text(userMessage),
    ];

    // 3. startChatを使わずに、generateContentで直接リクエストを送信
    final response = await _model.generateContent(fullContent);

    return response.text ?? 'すみません、うまく聞き取れませんでした。もう一度お願いします。';
  }
}
