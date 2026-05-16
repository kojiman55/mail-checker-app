# MailChecker (Flutter)

ビジネスメールの敬語・表現をAIが添削するiOS / Androidアプリ。

Web版（[mail-checker](https://github.com/kojiman55/mail-checker)）と同じAPIバックエンドを共有している。

## スクリーンショット

| iOS 入力画面 | iOS 添削結果 |
|---|---|
| ![iOS入力](https://portfolio.eggsystems.jp/screenshots/mail-checker-ios-input.png) | ![iOS結果](https://portfolio.eggsystems.jp/screenshots/mail-checker-ios-result.png) |

| Android 入力画面 | Android 添削結果 |
|---|---|
| ![Android入力](https://portfolio.eggsystems.jp/screenshots/mail-checker-app-input.jpg) | ![Android結果](https://portfolio.eggsystems.jp/screenshots/mail-checker-app-result.jpg) |

## 機能

- メール本文を入力するとAIが添削結果を返す
- 指摘を「誤り / 改善提案 / 参考情報」の3種類で分類表示
- 各指摘に元の表現・修正案・理由を表示
- AIによる総評
- 添削後の全文を生成してコピー
- 日本語・英語の両方に対応

## 技術スタック

| 項目 | 内容 |
|---|---|
| フレームワーク | Flutter |
| 言語 | Dart |
| HTTPクライアント | http パッケージ |
| バックエンド | AWS Lambda + API Gateway（Web版と共通） |
| AI | Gemini API |

バックエンドのソースコードは非公開。

## ファイル構成

```
lib/
  main.dart         エントリーポイント・アプリ設定
  home_screen.dart  メイン画面
  api.dart          APIクライアント・サンプルテキスト
  models.dart       データモデル
```

## ビルド方法

```bash
flutter pub get
flutter run
```

## 関連リポジトリ

- [mail-checker](https://github.com/kojiman55/mail-checker) — Web版（React）のコード

## ライセンス

MIT
