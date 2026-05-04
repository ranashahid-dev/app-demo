import 'package:flutter/material.dart';

// The main function to run the Flutter application
void main() {
  runApp(const MyApp());
}

// The main application widget, setting up the theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary App',
      theme: ThemeData(
        // Using a modern, blue-based theme
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Inter', // Custom font for modern UI
      ),
      home: const LoginScreen(),
    );
  }
}

// Stateful widget for the login screen to manage form state and loading
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key to validate the form
  final _formKey = GlobalKey<FormState>();
  // Controllers for text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Placeholder function to simulate the login process
  void _handleLogin() async {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _message = null;
        _isError = false;
      });

      // --- Simulation of API Call Delay (2 seconds) ---
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        // Simple success/error logic
        if (_emailController.text == 'test@dictionary.com' && _passwordController.text == 'password') {
          _message = 'Login successful! Welcome.';
          _isError = false;
          // In a real app, you would navigate to the home screen here.
        } else {
          _message = 'Invalid credentials. Please try again.';
          _isError = true;
        }
      });
    }
  }

  // Custom Gradient Text for the 'Dictionary Login' title
  Widget _buildGradientText(String text, double fontSize) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        // Defines the blue gradient
        return const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: Colors.white, // Color is masked by the gradient
        ),
      ),
    );
  }

  // Dictionary Icon replacement (using a standard Flutter icon)
  Widget _buildDictionaryIcon() {
    return const Icon(
      Icons.menu_book_rounded,
      size: 64,
      color: Color(0xFF2563EB),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size to make the card max-width responsive
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background color
      body: Center(
        // Use SingleChildScrollView to prevent overflow on smaller devices/keyboards
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            // Constrain the width for tablet/desktop views
            constraints: BoxConstraints(
              maxWidth: size.width > 600 ? 400 : double.infinity,
            ),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Color(0x15000000), // Soft shadow for depth
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 1. Header/Logo
                  Center(
                    child: Column(
                      children: [
                        _buildDictionaryIcon(),
                        const SizedBox(height: 12),
                        _buildGradientText('Dictionary Login', 30),
                        const SizedBox(height: 8),
                        Text(
                          'Access your vocabulary and search history',
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // 2. Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'you@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // 4. Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _message = 'Password reset link sent! (Simulated)';
                          _isError = false;
                        });
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Login Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 8, // Added subtle elevation
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Feedback Area
                  if (_message != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: _isError ? Colors.red[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: _isError ? Colors.red[300]! : Colors.green[300]!,
                        ),
                      ),
                      child: Text(
                        _message!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isError ? Colors.red[800] : Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // 7. Registration Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _message = 'Redirecting to sign-up page... (Simulated)';
                            _isError = false;
                          });
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
