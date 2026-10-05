import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:taeed_flutter/router/app_router.dart';

void main() {
  group('SEO & GEO Verification Suite', () {
    test('web/index.html contains production title and zero debug identifiers', () {
      final indexFile = File('web/index.html');
      expect(indexFile.existsSync(), isTrue);

      final content = indexFile.readAsStringSync();
      expect(content, contains('<title>Truthprenuer — Validate Startup Ideas with Humans + AI</title>'));
      expect(content, isNot(contains('taeed_flutter')));
      expect(content, isNot(contains('A new Flutter project')));
    });

    test('web/index.html includes complete canonical, robots, and rich meta tags', () {
      final content = File('web/index.html').readAsStringSync();

      // Canonical link
      expect(content, contains('<link rel="canonical" href="https://truthprenuer.pages.dev/">'));

      // Robots directives
      expect(content, contains('<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">'));

      // Open Graph
      expect(content, contains('<meta property="og:title" content="Truthprenuer — Validate Startup Ideas with Humans + AI">'));
      expect(content, contains('<meta property="og:url" content="https://truthprenuer.pages.dev/">'));
      expect(content, contains('<meta property="og:site_name" content="Truthprenuer">'));
      expect(content, contains('<meta property="og:image" content="https://truthprenuer.pages.dev/icons/Icon-512.png">'));

      // Twitter Cards
      expect(content, contains('<meta name="twitter:card" content="summary_large_image">'));
      expect(content, contains('<meta name="twitter:title" content="Truthprenuer — Validate Startup Ideas with Humans + AI">'));
    });

    test('web/index.html has valid Schema.org JSON-LD knowledge graph', () {
      final content = File('web/index.html').readAsStringSync();
      final scriptMatch = RegExp(r'<script type="application/ld\+json">([\s\S]*?)</script>').firstMatch(content);
      expect(scriptMatch, isNotNull, reason: 'JSON-LD structured data script must be present');

      final rawJson = scriptMatch!.group(1)!.trim();
      final decoded = json.decode(rawJson) as Map<String, dynamic>;

      expect(decoded['@context'], 'https://schema.org');
      final graph = decoded['@graph'] as List<dynamic>;
      expect(graph.isNotEmpty, isTrue);

      final types = graph.map((e) => e['@type']).toList();
      expect(types, contains('Organization'));
      expect(types, contains('WebSite'));
      expect(types, contains('SoftwareApplication'));
      expect(types, contains('WebPage'));

      final org = graph.firstWhere((e) => e['@type'] == 'Organization');
      expect(org['name'], 'Truthprenuer');
      expect(org['url'], 'https://truthprenuer.pages.dev/');
    });

    test('web/index.html includes crawlable semantic HTML shell with answer-first GEO content', () {
      final content = File('web/index.html').readAsStringSync();

      expect(content, contains('id="seo-prerender"'));
      expect(content, contains('<h1>Validate Your Startup Idea with Humans + AI</h1>'));
      expect(content, contains('<h2>What is Truthprenuer?</h2>'));
      expect(content, contains('<h2>Human Validation + AI Validation Architecture</h2>'));
      expect(content, contains('<h3>1. Human Validation</h3>'));
      expect(content, contains('<h3>2. AI-Powered Analysis</h3>'));
      expect(content, contains('<h3>3. Startup Health Scoring</h3>'));
      expect(content, contains('<h3>4. Ecosystem Networking</h3>'));
      expect(content, contains('<h2>Frequently Asked Questions</h2>'));

      // Internal links
      expect(content, contains('href="/startup-validation"'));
      expect(content, contains('href="/ai-startup-validation"'));
      expect(content, contains('href="/human-validation"'));
      expect(content, contains('href="/startup-analysis"'));
      expect(content, contains('href="/how-it-works"'));
    });

    test('web/robots.txt allows search/AI crawlers and points to valid sitemap', () {
      final robotsFile = File('web/robots.txt');
      expect(robotsFile.existsSync(), isTrue);

      final content = robotsFile.readAsStringSync();
      expect(content, contains('User-agent: *'));
      expect(content, contains('Allow: /'));
      expect(content, contains('Disallow: /admin/'));
      expect(content, contains('Disallow: /settings/'));
      expect(content, contains('User-agent: Googlebot'));
      expect(content, contains('User-agent: Bingbot'));
      expect(content, contains('User-agent: OAI-SearchBot'));
      expect(content, contains('User-agent: ClaudeBot'));
      expect(content, contains('User-agent: PerplexityBot'));
      expect(content, contains('Sitemap: https://truthprenuer.pages.dev/sitemap.xml'));
    });

    test('web/sitemap.xml contains primary canonical URLs with valid schema', () {
      final sitemapFile = File('web/sitemap.xml');
      expect(sitemapFile.existsSync(), isTrue);

      final content = sitemapFile.readAsStringSync();
      expect(content, contains('<?xml version="1.0" encoding="UTF-8"?>'));
      expect(content, contains('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/startup-validation</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/ai-startup-validation</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/human-validation</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/startup-analysis</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/startup-health</loc>'));
      expect(content, contains('<loc>https://truthprenuer.pages.dev/how-it-works</loc>'));
      expect(content, isNot(contains('/admin/')));
      expect(content, isNot(contains('/settings/')));
    });

    test('web/manifest.json contains Truthprenuer metadata and branding', () {
      final manifestFile = File('web/manifest.json');
      expect(manifestFile.existsSync(), isTrue);

      final content = manifestFile.readAsStringSync();
      final decoded = json.decode(content) as Map<String, dynamic>;
      expect(decoded['name'], 'Truthprenuer — Startup Validation Platform');
      expect(decoded['short_name'], 'Truthprenuer');
      expect(decoded['theme_color'], '#F44A22');
      expect(decoded['background_color'], '#0A0A0A');
    });

    test('web/_headers contains security headers and correct MIME types', () {
      final headersFile = File('web/_headers');
      expect(headersFile.existsSync(), isTrue);

      final content = headersFile.readAsStringSync();
      expect(content, contains('X-Content-Type-Options: nosniff'));
      expect(content, contains('X-Frame-Options: SAMEORIGIN'));
      expect(content, contains('Content-Type: text/plain; charset=utf-8'));
      expect(content, contains('Content-Type: application/xml; charset=utf-8'));
    });

    test('app_router supports public SEO topic cluster routes', () {
      final routes = appRouter.configuration.routes;
      final paths = routes.whereType<GoRoute>().map((r) => r.path).toList();

      expect(paths, contains('/startup-validation'));
      expect(paths, contains('/ai-startup-validation'));
      expect(paths, contains('/human-validation'));
      expect(paths, contains('/startup-analysis'));
      expect(paths, contains('/how-it-works'));
    });
  });
}
