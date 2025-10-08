import 'package:expenses_tracker/widgets/TextInputs.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 150),

          Center(
            child: SvgPicture.asset(
              "assets/logos/logoipsium-title-branding.svg",
              width: 86,
              height: 86,
            ),
          ),
      
          const SizedBox(height: 45),

          Padding(
            padding: const EdgeInsets.fromLTRB(48,0,0,0),
            child: Text(
              "Login to your Account",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 84, 84, 84)
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(32,32,32,0),
            child: ElevatedTextInput(
              hintText: "Email",
              inputType: TextInputType.emailAddress,
            ),
          ),

          SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.fromLTRB(32,0,32,0),
            child: ElevatedTextInput(
              hintText: "Password",
              inputType: TextInputType.visiblePassword,
            ),
          ),

          SizedBox(height: 25),

          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(250,60)),
                elevation: WidgetStatePropertyAll(3),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 222, 187, 255))
              ),

              child: Text(
                "Sign In",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Color.fromARGB(255, 84, 84, 84)
                ),
              ),

              onPressed: () {}, 
            ),
          ),

          SizedBox(height: 45),

          Center(
            child: Text(
              "- Or sign in with -",
              style: TextStyle(color:  Color.fromARGB(255, 135, 135, 135)),
            )
          ),

          SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(3),
                  minimumSize: WidgetStatePropertyAll(Size(75,50)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),

                onPressed: () {},
                child: SvgPicture.asset(
                  "assets/icons/google-icon.svg",
                 width: 25,
                 height: 25,
                 colorFilter: ColorFilter.mode(Color.fromARGB(255, 87, 168, 255), BlendMode.srcIn),
                )
              ),
              
              ElevatedButton(
                style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(3),
                  minimumSize: WidgetStatePropertyAll(Size(75,50)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),

                onPressed: () {},
                child: SvgPicture.asset(
                  "assets/icons/facebook-icon.svg",
                 width: 25,
                 height: 25,
                 colorFilter: ColorFilter.mode(Color.fromARGB(255, 165, 100, 255), BlendMode.srcIn),
                )
              ),

              ElevatedButton(
                style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(3),
                  minimumSize: WidgetStatePropertyAll(Size(75,50)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),

                onPressed: () {},
                child: SvgPicture.asset(
                  "assets/icons/steam-icon.svg",
                 width: 25,
                 height: 25,
                 colorFilter: ColorFilter.mode(Color.fromARGB(255, 255, 109, 189), BlendMode.srcIn),
                )
              ),
            ],
          ),

          SizedBox(height: 85),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:  Color.fromARGB(255, 135, 135, 135)
                  )
                ),

                TextButton(onPressed: () {}, child: Text("Sign Up"))
              ],
            )
          )

        ],
      ),
    );
  }
}