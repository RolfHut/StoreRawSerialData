/**
 * SerialreadandstoreRAW
 * This program reads out a line from the serialport and stores it in a file. 
 * It waits for a linefeed (enter) untill it reads out the serial buffer again.
 * the starting and closing of the file is done by keyboard commands.
 */



import processing.serial.*;

Serial myPort;        // The serial port
PrintWriter outputRaw;   // The output file
//PrintWriter outputManual;   // The output file

//compter related 
String location = "/Users/rwhut/Documents/TU/rawData/";
int portNumber = 4;  //the number of the serial port. see the print of the serial port list in de debug window
int BAUDRATE = 9600;


//experiment related
String Datum = "20151028";
String experimentName = "waderFlumeEx6_HighFlow_Foot";

int lines = 0;
int manualCounter = 0;
String inString;

void setup() {
  size(600,100);
  

  //create the name of the outfile and the outputfile, also open the file.
 String outfileRaw = location + Datum + experimentName + ".asc";
 //String outfileManual = location + Datum + experimentName + "manual.asc";
 outputRaw = createWriter(outfileRaw); //create the file
 //outputManual = createWriter(outfileManual); //create the file
 //output.println("First line");
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always the device I need, so I open Serial.list()[0].
  // Open whatever port is the one you"re using.
  myPort = new Serial(this, Serial.list()[portNumber], BAUDRATE);
  // don"t generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  inString = myPort.readStringUntil('\n');

  if (inString != null) {
    
    //print timestamp to file
    outputRaw.print(hour() + ":" + minute() + ":" + second() + ",");
    
    //print received data to file
    // trim off any whitespace:
    inString = trim(inString);
    outputRaw.println(inString); //send the data to the file
    
    //update received lines counter
    lines=lines+1;
  }    
}

void draw() {
  clear();
  if(keyPressed) {
    if (key == 's' || key == 'S') {
          delay(2000);
          myPort.stop();
          //output.println("last line");
          outputRaw.flush(); // Write the remaining data
          outputRaw.close(); // Finish the file
          //outputManual.flush(); // Write the remaining data
          //outputManual.close(); // Finish the file
          delay(1000);
          exit();
    }
    /*else if (key == 'm' || key == 'M'){
      //print timestamp to file
      outputManual.print(hour() + ":" + minute() + ":" + second() + ",");
    
      //print received data to file
      // trim off any whitespace:
      inString = trim(inString);
      outputManual.println(inString); //send the data to the file
      manualCounter = manualCounter + 1;
      delay(1000);
    }*/
      
  }
  text(str(manualCounter) + " " + str(lines) + " " + inString,10,10);
}

