import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/home_carousel.dart';

// Mock HTTP overrides for NetworkImage
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpHeaders extends Fake implements HttpHeaders {}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

final List<int> _transparentImage = [
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00,
  0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21, 0xf9, 0x04, 0x01, 0x00, 0x00, 0x00,
  0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02,
  0x44, 0x01, 0x00, 0x3b
];

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: HomeCarousel()),
        ),
        GoRoute(
          path: '/sale',
          builder: (context, state) => const Scaffold(body: Text('Sale Page')),
        ),
        GoRoute(
          path: '/collections',
          builder: (context, state) =>
              const Scaffold(body: Text('Collections Page')),
        ),
        GoRoute(
          path: '/print-shack',
          builder: (context, state) =>
              const Scaffold(body: Text('Print Shack Page')),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const Scaffold(body: Text('About Page')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('HomeCarousel displays first item correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Allow image loading

    expect(find.text('CHECK OUT THE SALE!'), findsOneWidget);
    expect(find.text("Don't miss out on our exclusive sale items!"),
        findsOneWidget);
    expect(find.text('GO TO SALE'), findsOneWidget);
  });

  testWidgets('HomeCarousel navigates when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    final button = find.widgetWithText(ElevatedButton, 'GO TO SALE');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Sale Page'), findsOneWidget);
  });

  testWidgets('HomeCarousel auto-plays to next item',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Initial state
    expect(find.text('CHECK OUT THE SALE!'), findsOneWidget);

    // Wait for timer (5 seconds) + animation
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Should be on second item
    expect(find.text('BROWSE COLLECTIONS'), findsOneWidget);
    expect(find.text('VIEW COLLECTIONS'), findsOneWidget);
  });

  testWidgets('HomeCarousel manual navigation works (Desktop)',
      (WidgetTester tester) async {
    // Set size to desktop to show arrows
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Find next arrow
    final nextArrow = find.byIcon(Icons.arrow_forward_ios);
    expect(nextArrow, findsOneWidget);

    // Tap next
    await tester.tap(nextArrow);
    await tester.pumpAndSettle();

    // Should be on second item
    expect(find.text('BROWSE COLLECTIONS'), findsOneWidget);

    // Find prev arrow
    final prevArrow = find.byIcon(Icons.arrow_back_ios);
    expect(prevArrow, findsOneWidget);

    // Tap prev
    await tester.tap(prevArrow);
    await tester.pumpAndSettle();

    // Should be back on first item
    expect(find.text('CHECK OUT THE SALE!'), findsOneWidget);
  });
}
