import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:howdy/screens/authentication/sign_in.dart';
import 'package:howdy/screens/user_pages/home.dart';
import 'package:howdy/screens/user_pages/new_post.dart';
import 'package:howdy/screens/user_pages/user_profile.dart';
// import 'package:howdy/services/auth.dart';
// import 'package:howdy/screens/user_pages/home.dart';
import 'package:howdy/services/wrapper.dart';
import 'package:howdy/widgets/interest_widget.dart';
import 'package:howdy/widgets/post_feed.dart';
import 'package:integration_test/integration_test.dart';

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Wrapper testWrapper = Wrapper();
  return testWrapper;
}

void main() {
  group('Integration test', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    testWidgets('Check login account', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      // await tester.tap(find.widgetWithText(TextButton, "Siguiente"));
      // await tester.tap(find.widgetWithText(TextButton, "Siguiente"));
      // await tester.tap(find.widgetWithText(TextButton, "Siguiente"));
      // await tester
      //     .tap(find.widgetWithText(ElevatedButton, '\nYa tengo una cuenta\n'));
      // await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(Home), findsOneWidget);
    });
    testWidgets('Configuration of profile page', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithText(ListTile, "Editar perfil"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(UserDetailView), findsOneWidget);
    });
    testWidgets('Choose & see interests', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);

      await tester.tap(find.widgetWithText(ListTile, "Editar perfil"));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(UserInterestWidget), findsOneWidget);
    });
    testWidgets('See publications of other users', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(Post), findsWidgets);
    });
    testWidgets('See profile of other users', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.tap(find.byType(Post));
      expect(find.byType(Post), findsWidgets);
    });
    testWidgets('create Post', (tester) async {
      Widget w = await createHomeScreen();
      await tester.pumpWidget(w);
      await tester
          .tap(find.widgetWithIcon(FloatingActionButton, Icons.post_add));
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(find.byType(NewPost), findsOneWidget);
    });
  });
}
