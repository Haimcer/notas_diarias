import 'package:flutter/material.dart';
import '../widget/change_button.dart';
import '../widget/display_registration_screen.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas anotações"),
          backgroundColor: Theme.of(context).iconTheme.color,
          actions: [
            ChangeThemeButtonWidget(),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
            foregroundColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).iconTheme.color,
            child: Icon(Icons.add_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return exibirTela();
                  });
            }));
  }
}
