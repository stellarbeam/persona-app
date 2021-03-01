import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persona/blocs/connectivity_bloc/connectivity_bloc.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ConnectivityBloc', () {
    ConnectivityBloc connectivityBloc;

    setUp(() {
      connectivityBloc = ConnectivityBloc();
    });

    tearDown(() {
      connectivityBloc.close();
    });

    test("initial connection status must be connected:false", () {
      expect(connectivityBloc.state, ConnectivityState(connected: false));
    });

    blocTest(
      "connection status on sending ConnectivityStatusChanged(ConnectivityResult.none) event must be connected:false",
      build: () => connectivityBloc,
      act: (ConnectivityBloc bloc) =>
          bloc.add(ConnectivityStatusChanged(ConnectivityResult.none)),
      expect: [ConnectivityState(connected: false)],
    );

    blocTest(
      "connection status on sending ConnectivityStatusChanged(ConnectivityResult.mobile) event must be connected:true",
      build: () => connectivityBloc,
      act: (ConnectivityBloc bloc) =>
          bloc.add(ConnectivityStatusChanged(ConnectivityResult.mobile)),
      expect: [ConnectivityState(connected: true)],
    );

    blocTest(
      "connection status on sending ConnectivityStatusChanged(ConnectivityResult.wifi) event must be connected:true",
      build: () => connectivityBloc,
      act: (ConnectivityBloc bloc) =>
          bloc.add(ConnectivityStatusChanged(ConnectivityResult.wifi)),
      expect: [ConnectivityState(connected: true)],
    );
  });
}
