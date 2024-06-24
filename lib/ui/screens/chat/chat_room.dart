import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_client/ui/screens/chat/chat_screen.dart';
import '../../../blocs/guard/guard_bloc.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<GuardBloc>().add(FetchGuards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Set the custom height
        child: AppBar(
          title: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                  child: Text(
                'Chat',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ))),
          surfaceTintColor: Color.fromARGB(255, 245, 247, 250),
          backgroundColor: Color.fromARGB(255, 245, 247, 250),
          elevation: 0, // Remove shadow
        ),
      ),
      body: BlocBuilder<GuardBloc, GuardState>(
        builder: (context, state) {
          if (state is GuardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GuardError) {
            return Center(child: Text('Failed to load Guards'));
          } else if (state is GuardListLoaded) {
            return ListView.builder(
              itemCount: state.guards.length,
              itemBuilder: (context, index) {
                final guard = state.guards[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Color.fromARGB(100, 200, 200, 200),
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(guard.firstName?.substring(0, 1) ?? '?'),
                    ),
                    title: Text(
                        '${guard.firstName ?? ''} ${guard.lastName ?? ''}'),
                    subtitle:
                        Text(guard.email, style: TextStyle(color: Colors.grey)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(guard: guard),
                        ),
                      ).then((_) {
                        // Refresh the list when coming back from the detail screen
                        context.read<GuardBloc>().add(FetchGuards());
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No Guards available'));
          }
        },
      ),
    );
  }
}
