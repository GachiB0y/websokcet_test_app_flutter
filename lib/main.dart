import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> messages = [];
  late IOWebSocketChannel _channel;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://10.3.50.96:9876/ws');
    _channel.stream.listen((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildMessagesList() {
    return Expanded(
      child: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          messages.add(snapshot.data);
          print(_channel.stream);
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Text(messages[index]);
              },
            );
          } else {
            return Text('Подключение...');
          }
        },
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        hintText: 'Введите сообщение',
      ),
      onSubmitted: (value) {
        _channel.sink.add(value);
        _textEditingController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Demo'),
      ),
      body: Column(
        children: [
          _buildMessagesList(),
          Divider(),
          _buildTextField(),
        ],
      ),
    );
  }
}

// class SocketIOExample extends StatefulWidget {
//   @override
//   _SocketIOExampleState createState() => _SocketIOExampleState();
// }

// class _SocketIOExampleState extends State<SocketIOExample> {
//   List<String> messages = [];

//   @override
//   void initState() {
//     super.initState();

//     // // Установка соединения с сервером на указанном адресе и порту
//     // IO.Socket socket = IO.io('http://10.3.50.96:9876');

//     // socket.on('connect', (_) {
//     //   print('Connected');
//     // });

//     // socket.on('message', (data) {
//     //   // Обновление списка сообщений при получении ответа от сервера
//     //   setState(() {
//     //     messages.add(data['message']);
//     //   });
//     // });

//     // socket.on('disconnect', (_) {
//     //   print('Disconnected');
//     // });

//     // socket.connect();
//     connectAndListen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Socket IO Example'),
//       ),
//       body: BuildWithSocketStream(),
//     );
//   }
// }

// class StreamSocket {
//   final _socketResponse = StreamController<String>();

//   void Function(String) get addResponse => _socketResponse.sink.add;

//   Stream<String> get getResponse => _socketResponse.stream;

//   void dispose() {
//     _socketResponse.close();
//   }
// }

// StreamSocket streamSocket = StreamSocket();

// //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
// void connectAndListen() {
//   IO.Socket socket = IO.io('http://10.3.50.96:9876',
//       IO.OptionBuilder().setTransports(['websocket']).build());

//   socket.onConnect((_) {
//     print('connect');
//     socket.emit('msg', 'test');
//   });

//   //When an event recieved from server, data is added to the stream
//   socket.on('event', (data) => streamSocket.addResponse);
//   socket.onDisconnect((_) => print('disconnect'));
// }

// //Step3: Build widgets with streambuilder

// class BuildWithSocketStream extends StatelessWidget {
//   const BuildWithSocketStream({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: streamSocket.getResponse,
//         builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               padding: EdgeInsets.all(8.0),
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return Text(snapshot.data!);
//               },
//             );
//           } else {
//             return Text('Подключение...');
//           }
//         },
//       ),
//     );
//   }
// }
