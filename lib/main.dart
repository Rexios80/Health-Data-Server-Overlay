import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hds_overlay/repos/socket_server_repo.dart';
import 'package:hds_overlay/utils/material_color.dart';
import 'package:hds_overlay/utils/null_safety.dart';

import 'blocs/socket_server/socket_server_bloc.dart';
import 'interface/log_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DesktopWindow.setWindowSize(Size(1000, 500));
    DesktopWindow.setMaxWindowSize(Size(1000, 500));
    DesktopWindow.setMinWindowSize(Size(1000, 500));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xffe35c89)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (context) {
                var socketServerBloc = SocketServerBloc(SocketServerRepo(3476));
                socketServerBloc.add(SocketServerEventStart());
                return socketServerBloc;
              },
              child: MyHomePage(),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SocketServerBloc socketServerBloc =
        BlocProvider.of<SocketServerBloc>(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder<SocketServerState>(
      stream: socketServerBloc.stream,
      builder: (context, socketServerState) {
        final state = socketServerState.data;

        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('Health Data Server'),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  cast<SocketServerStateRunning>(state)?.message?.value ?? '',
                ),
                Spacer(),
                LogView(log: cast<SocketServerStateRunning>(state)?.log ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
