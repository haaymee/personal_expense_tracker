import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30, weight: 10, color: Colors.black),
          onPressed: () {}, 
        ),
        
        actions: [
          
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.search_rounded, size: 30, weight: 10, color: Colors.black)
                ),
                
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.calendar_month, size: 30, weight: 10, color: Colors.black)
                ),
              ],
            ),
          ),

        ],
      ),

      body: Column(
        children: [

          SizedBox(height: 24),

          HeadingBalanceContainer(),
          
        ],
      ),
    );
  }
}

class HeadingBalanceContainer extends StatelessWidget {
  const HeadingBalanceContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 163, 223, 255)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            VerticalCounterLabel(
              label: "Expenses",
              labelStyle: TextStyle(),
              
              counterVal: "3,000",
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
    
            Text(
              "|",
              style: Theme.of(context).textTheme.displaySmall
            ),
            
            VerticalCounterLabel(
              label: "Income",
              labelStyle: TextStyle(),
              
              counterVal: "60,000",
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
    
            Text(
              "|",
              style: Theme.of(context).textTheme.displaySmall
            ),
    
            VerticalCounterLabel(
              label: "Balance",
              labelStyle: TextStyle(),
              
              counterVal: "57,000",
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
    
          ],
        ),
      ),
    );
  }
}