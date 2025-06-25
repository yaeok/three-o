import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart' as app;

// 注意: このファイルは `http` パッケージに依存しています。
// pubspec.yaml の dependencies に `http: ^1.2.1` (または最新版) を追加してください。

class GeminiService {
  // httpパッケージを直接利用するため、コンストラクタは空で問題ありません。
  GeminiService();

  // AIからの応答を生成する
  Future<String> generateResponse({
    required Agent agent,
    required List<app.Message> history,
    required String userMessage,
  }) async {
    // 1. APIキーとエンドポイントの準備
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('.env.developmentファイルにGEMINI_API_KEYが見つかりません。');
    }
    const model = 'gemini-1.5-flash';
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    // 2. AIの役割を定義するシステムプロンプトを作成
    final systemPrompt =
        'あなたは「${agent.name}」という名前のAIアシスタントです。'
        '役職は「${agent.role}」です。'
        'あなたの性格と口調は以下の通りです。「${agent.personality}」'
        'あなたは以下の業界知識に特化しています。「${agent.industryInfo}」'
        '# 制約'
        '設定に忠実に、ユーザーからの相談に親身に答えてください。'
        '- 100文字以内で、日本語で回答してください。'
        '- 友人やメンターのように、優しく励ますような口調で話してください。';

    // 3. APIリクエスト用の会話履歴を作成
    final contents = [
      ...history.map(
        (msg) => {
          'role': msg.sender == app.SenderRole.user ? 'user' : 'model',
          'parts': [
            {'text': msg.text},
          ],
        },
      ),
      // 今回のユーザーメッセージを追加
      {
        'role': 'user',
        'parts': [
          {'text': userMessage},
        ],
      },
    ];

    // 4. APIリクエストのbodyを組み立てる
    final requestBody = jsonEncode({
      'contents': contents,
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'safetySettings': [
        {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
        {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_NONE'},
        {
          'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
          'threshold': 'BLOCK_NONE',
        },
        {
          'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
          'threshold': 'BLOCK_NONE',
        },
      ],
    });

    // 5. APIにリクエストを送信し、応答を待つ
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // UTF-8でレスポンスをデコード
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

        // 応答がブロックされた、または候補がない場合
        if (decodedBody['candidates'] == null ||
            (decodedBody['candidates'] as List).isEmpty) {
          final blockReason = decodedBody['promptFeedback']?['blockReason']
              ?.toString();
          if (blockReason != null) {
            throw Exception('不適切なコンテンツとしてブロックされました: $blockReason');
          }
          return 'すみません、応答を生成できませんでした。';
        }

        return decodedBody['candidates'][0]['content']['parts'][0]['text'] ??
            '応答テキストの取得に失敗しました。';
      } else {
        // APIからエラーが返ってきた場合
        if (kDebugMode) {
          print('Gemini API Error: ${response.statusCode}, ${response.body}');
        }
        throw Exception('APIリクエストに失敗しました。Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('GeminiService Error: $e');
      }
      // UI側でエラーハンドリングできるよう、例外を再スロー
      rethrow;
    }
  }
}
