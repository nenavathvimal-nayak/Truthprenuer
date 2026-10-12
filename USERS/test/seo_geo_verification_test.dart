import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:taeed_flutter/router/app_router.dart';

void main() {
  group('SEO & GEO Production Quality Verification Tests', () {
    test('web/index.html has production title, canonical, meta and social tags', () {
      final file = File('web/index.html');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();

      // 1. Identity & Title
      expect(content.contains('<title>Truthprenuer — Validate Startup Ideas with Humans + AI</title>'), isTrue);
      expect(content.contains('taeed_flutter'), isFalse, reason: 'Must not leak development project names');

      // 2. Canonical & Viewport
      expect(content.contains('<link rel="canonical" href="https://truthprenuer.pages.dev/">'), isTrue);
      expect(content.contains('name="viewport"'), isTrue);

      // 3. Open Graph Metadata
      expect(content.contains('property="og:title" content="Truthprenuer — Validate Startup Ideas with Humans + AI"'), isTrue);
      expect(content.contains('property="og:url" content="https://truthprenuer.pages.dev/"'), isTrue);
      expect(content.contains('property="og:type" content="website"'), isTrue);
      expect(content.contains('property="og:image"'), isTrue);

      // 4. Twitter / X Cards
      expect(content.contains('name="twitter:card" content="summary_large_image"'), isTrue);
      expect(content.contains('name="twitter:title"'), isTrue);
      expect(content.contains('name="twitter:description"'), isTrue);
    });

    test('web/index.html contains valid Schema.org JSON-LD graph', () {
      final content = File('web/index.html').readAsStringSync();
      final scriptMatch = RegExp(r'<script type="application/ld\+json">([\s\S]*?)<\/script>').firstMatch(content);
      expect(scriptMatch, isNotNull);

      final jsonStr = scriptMatch!.group(1)!.trim();
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(jsonMap['@context'], 'https://schema.org');
      final graph = jsonMap['@graph'] as List<dynamic>;
      expect(graph.isNotEmpty, isTrue);

      final types = graph.map((e) => e['@type']).toList();
      expect(types.contains('Organization'), isTrue);
      expect(types.contains('WebSite'), isTrue);
      expect(types.contains('SoftwareApplication'), isTrue);
      expect(types.contains('WebPage'), isTrue);

      final org = graph.firstWhere((e) => e['@type'] == 'Organization') as Map<String, dynamic>;
      expect(org['name'], 'Truthprenuer');
      expect(org['url'], 'https://truthprenuer.pages.dev/');
    });

    test('web/index.html contains semantic crawler prerender shell with direct answers', () {
      final content = File('web/index.html').readAsStringSync();

      // Heading hierarchy
      expect(content.contains('<h1>Validate Your Startup Idea with Humans + AI</h1>'), isTrue);
      expect(content.contains('<h2>What is Truthprenuer?</h2>'), isTrue);
      expect(content.contains('<h2>Human Validation vs AI Validation</h2>'), isTrue);

      // GEO Answer-First text
      expect(content.contains('Truthprenuer is an empirical startup validation platform'), isTrue);

      // Semantic navigation links for crawler discovery
      expect(content.contains('href="/startup-validation"'), isTrue);
      expect(content.contains('href="/ai-startup-validation"'), isTrue);
      expect(content.contains('href="/human-validation"'), isTrue);
      expect(content.contains('href="/startup-analysis"'), isTrue);
      expect(content.contains('href="/top-validators"'), isTrue);
    });

    test('web/robots.txt allows root and blocks only private routes with valid sitemap', () {
      final file = File('web/robots.txt');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();

      expect(content.contains('User-agent: *'), isTrue);
      expect(content.contains('Allow: /'), isTrue);
      expect(content.contains('Disallow: /admin/'), isTrue);
      expect(content.contains('Disallow: /settings/'), isTrue);
      expect(content.contains('Sitemap: https://truthprenuer.pages.dev/sitemap.xml'), isTrue);
    });

    test('web/sitemap.xml contains valid XML and all canonical topic cluster URLs', () {
      final file = File('web/sitemap.xml');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();

      expect(content.startsWith('<?xml version="1.0" encoding="UTF-8"?>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/startup-validation</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/ai-startup-validation</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/human-validation</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/startup-analysis</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/how-it-works</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/explore</loc>'), isTrue);
      expect(content.contains('<loc>https://truthprenuer.pages.dev/top-validators</loc>'), isTrue);
    });

    test('web/manifest.json uses clean Truthprenuer branding', () {
      final file = File('web/manifest.json');
      expect(file.existsSync(), isTrue);
      final manifest = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

      expect(manifest['name'], contains('Truthprenuer'));
      expect(manifest['short_name'], 'Truthprenuer');
      expect(manifest['name'].toString().contains('taeed_flutter'), isFalse);
    });

    test('AppRouter configuration includes public SEO topic cluster routes', () {
      final routes = appRouter.configuration.routes;
      final paths = routes.whereType<GoRoute>().map((r) => r.path).toList();

      expect(paths.contains('/startup-validation'), isTrue);
      expect(paths.contains('/ai-startup-validation'), isTrue);
      expect(paths.contains('/human-validation'), isTrue);
      expect(paths.contains('/startup-analysis'), isTrue);
      expect(paths.contains('/how-it-works'), isTrue);
      expect(paths.contains('/about'), isTrue);
      expect(paths.contains('/faq'), isTrue);
    });
  });
}
