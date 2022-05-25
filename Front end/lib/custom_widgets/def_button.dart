import 'package:flutter/material.dart';
import 'package:hcfd/main.dart';
import 'package:hcfd/styles/colors.dart';
import 'package:path/path.dart';

class DefaultButton extends StatelessWidget {
  late final String buttonText;
  late final Color buttonColor;
  late final Icon buttonIcon;
  late Function onPress;

  DefaultButton(this.buttonText, this.buttonColor, this.buttonIcon, this.onPress);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w * 0.8,
      height: h * 0.05,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
          onPressed: () {
            onPress();
          },
          child: Padding(
            padding:  EdgeInsets.fromLTRB(0, 0, w * 0.04, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
                Icon (buttonIcon.icon,
                size: 30,
                    color: Colors.blue[600],
                ),
                SizedBox(width: w*0.02,),

                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                  ),
                ),
              ],
            ),
          )
          ),
    );
  }
}
