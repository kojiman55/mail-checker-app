import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api.dart';
import 'models.dart';

class MailCheckerHome extends StatefulWidget {
  const MailCheckerHome({super.key});

  @override
  State<MailCheckerHome> createState() => _MailCheckerHomeState();
}

class _MailCheckerHomeState extends State<MailCheckerHome> {
  Language _lang = Language.ja;
  final _controller = TextEditingController();
  bool _loading = false;
  ReviewResponse? _response;
  String? _error;

  static const _maxLength = 500;
  static const _purple = Color(0xFF6d28d9);
  static const _purpleDark = Color(0xFF4c1d95);

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _response = null;
    });
    try {
      final res = await reviewEmail(text, _lang);
      setState(() => _response = res);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _loadSample() {
    _controller.text = _lang == Language.ja ? sampleJa : sampleEn;
    setState(() {
      _response = null;
      _error = null;
    });
  }

  void _setLang(Language lang) {
    setState(() {
      _lang = lang;
      _response = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 768;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildInputPanel()),
                    Container(width: 1, color: const Color(0xFFe5e7eb)),
                    Expanded(child: _buildResultPanel()),
                  ],
                );
              }
              return _response != null || _loading || _error != null
                  ? _buildResultPanel()
                  : _buildInputPanel();
            }),
          ),
          _buildNoticeBar(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4c1d95), Color(0xFF6d28d9)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.mark_email_read_outlined,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ビジネスメール添削',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text('AI による日英ビジネスメールの添削サービス',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            _buildLangToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLangToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _langBtn('🇯🇵', Language.ja),
          _langBtn('🇺🇸', Language.en),
        ],
      ),
    );
  }

  Widget _langBtn(String flag, Language lang) {
    final active = _lang == lang;
    return GestureDetector(
      onTap: () => _setLang(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          flag,
          style: TextStyle(
            fontSize: 14,
            color: active ? _purple : Colors.white,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInputPanel() {
    final charCount = _controller.text.length;
    final canSubmit = charCount > 0 && charCount <= _maxLength && !_loading;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.article_outlined,
                  size: 16, color: Color(0xFF6b7280)),
              const SizedBox(width: 6),
              const Text('メール本文',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151))),
              const Spacer(),
              TextButton(
                onPressed: _loading ? null : _loadSample,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('サンプルを読み込む',
                    style: TextStyle(fontSize: 12, color: _purple)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              enabled: !_loading,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (_) => setState(() {}),
              inputFormatters: [LengthLimitingTextInputFormatter(_maxLength)],
              decoration: InputDecoration(
                counterText: '',
                hintText: _lang == Language.ja
                    ? 'ビジネスメールの本文を貼り付けてください…'
                    : 'Paste your business email here…',
                hintStyle:
                    const TextStyle(color: Color(0xFFd1d5db), fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFe5e7eb)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFe5e7eb)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _purple, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('$charCount / ${_maxLength}文字',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9ca3af))),
              const Spacer(),
              ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFddd6fe),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('✨ 添削する',
                        style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultPanel() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.star_outline,
                  size: 16, color: Color(0xFF6b7280)),
              const SizedBox(width: 6),
              const Text('添削結果',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151))),
              if (_response != null) ...[
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _response = null),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('戻る',
                      style: TextStyle(fontSize: 12, color: _purple)),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildResultContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultContent() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            children: [
              CircularProgressIndicator(color: _purple),
              SizedBox(height: 16),
              Text('AIが添削中です…',
                  style: TextStyle(color: Color(0xFF6b7280))),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFfef2f2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFfecaca)),
        ),
        child: Text(_error!,
            style: const TextStyle(
                color: Color(0xFFdc2626), fontSize: 13)),
      );
    }

    if (_response == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(Icons.auto_awesome_outlined,
                  size: 48, color: Color(0xFFc4b5fd)),
              SizedBox(height: 12),
              Text('添削結果がここに表示されます',
                  style: TextStyle(
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Text('メール本文を入力して「添削する」を押してください',
                  style:
                      TextStyle(color: Color(0xFF9ca3af), fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    final r = _response!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (r.summary != null) _buildSummaryCard(r.summary!),
        if (r.issues.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('指摘ポイント', Icons.flag_outlined),
          const SizedBox(height: 8),
          ...r.issues.map(_buildIssueCard),
        ],
        if (r.correctedText != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('修正案', Icons.edit_outlined),
          const SizedBox(height: 8),
          _buildCorrectedText(r.correctedText!),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf5f3ff), Color(0xFFede9fe)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFddd6fe)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.summarize_outlined, size: 16, color: _purple),
              SizedBox(width: 6),
              Text('総評',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _purpleDark)),
            ],
          ),
          const SizedBox(height: 8),
          Text(summary,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF374151),
                  height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6b7280)),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151))),
      ],
    );
  }

  Widget _buildIssueCard(ReviewIssue issue) {
    final (color, bgColor, label) = switch (issue.type) {
      IssueType.error => (
          const Color(0xFFdc2626),
          const Color(0xFFfef2f2),
          'エラー'
        ),
      IssueType.warning => (
          const Color(0xFFd97706),
          const Color(0xFFfffbeb),
          '警告'
        ),
      IssueType.info => (
          const Color(0xFF2563eb),
          const Color(0xFFeff6ff),
          'ヒント'
        ),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(issue.original,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          if (issue.suggestion.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('→ ${issue.suggestion}',
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF374151))),
          ],
          if (issue.reason.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(issue.reason,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF6b7280))),
          ],
        ],
      ),
    );
  }

  Widget _buildCorrectedText(String text) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFf9fafb),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFe5e7eb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('コピーしました'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 14, color: _purple),
                  label: const Text('コピー',
                      style: TextStyle(fontSize: 12, color: _purple)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: SelectableText(
              text,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF374151), height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBar() {
    return Container(
      color: const Color(0xFFfffbeb),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        children: [
          Text('⚠️', style: TextStyle(fontSize: 12)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '添削結果はAIによる提案です。最終判断はご自身でご確認ください。個人情報・機密情報は入力しないでください。',
              style: TextStyle(fontSize: 11, color: Color(0xFF92400e)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFFf3f4f6),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Center(
        child: Text('© 2025 eggsystems.jp',
            style: TextStyle(fontSize: 11, color: Color(0xFF9ca3af))),
      ),
    );
  }
}
