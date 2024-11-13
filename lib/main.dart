import 'package:event_deskop_app/core/component/custom_button_widget.dart';
import 'package:event_deskop_app/features/auth/auth_provider.dart';
import 'package:event_deskop_app/features/event_category/ticket_provider.dart';
import 'package:event_deskop_app/features/events/events_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TicketProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          home: const LoginPage(title: 'Event App'),
        ));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title});

  final String? title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 100,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   leading: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Image.asset("assets/images/perbadanan_putrajaya-logo.png"),
      //   ),
      //   leadingWidth: 100,
      //   titleTextStyle: const TextStyle(
      //       color: Colors.white70,
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //       fontFamily: 'Roboto'),
      //   title: Text(widget.title),
      // ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/perbadanan_putrajaya-logo.png",
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButtonWidget(
                icon: Icons.login,
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    AuthProvider authProvider = AuthProvider();
                    bool logged = await authProvider.login(
                        email: emailController.text,
                        password: passwordController.text);

                    if (logged) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventsView()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Login Failed. Invalid Credentials')),
                      );
                    }
                  }
                },
                tooltip: "Login",
                btnName: "Login",
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
    );
  }
}
