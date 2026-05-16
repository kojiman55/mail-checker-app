import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

const _apiBase =
    'https://5uikebcnrc.execute-api.ap-northeast-1.amazonaws.com/prod';

const sampleJa = '''株式会社△△
田中部長様

お世話になっております。
株式会社〇〇営業部の山田でございます。

先日ご依頼いただきました件につきまして、ご報告させていただきたく存じます。

ご確認させていただきたい点が2点ございますので、ご教示いただければと思っております。
①納品日程についてですが、来週中にご対応していただけますでしょうか。
②お見積り金額につきまして、再度ご確認させていただけますでしょうか。

ご多忙のところ大変恐縮ではございますが、何卒よろしくお願いいたします。

山田 太郎''';

const sampleEn = '''Dear Mr. Smith,

Hope you are doing well.
I'm writing to ask about the project status ASAP.

We need the report by end of this week. Can you send it to me as soon as possible?
Also, FYI, the meeting has been changed to Thursday.

Please let me know if you have any questions.

Thanks,
Taro Yamada''';

Future<ReviewResponse> reviewEmail(String text, Language lang) async {
  final res = await http.post(
    Uri.parse('$_apiBase/review'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'text': text,
      'language': lang == Language.ja ? 'ja' : 'en',
    }),
  );
  if (res.statusCode != 200) throw Exception('API error: ${res.statusCode}');
  return ReviewResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
}
