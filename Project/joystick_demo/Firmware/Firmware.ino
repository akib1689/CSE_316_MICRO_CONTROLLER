
// Include Libraries
#include "Joystick.h"


// Pin Definitions
#define JOYSTICK_1_PIN_SW	2
#define JOYSTICK_1_PIN_VRX	A0
#define JOYSTICK_1_PIN_VRY	A1
#define JOYSTICK_2_PIN_SW	3
#define JOYSTICK_2_PIN_VRX	A2
#define JOYSTICK_2_PIN_VRY	A3



// Global variables and defines

// object initialization
Joystick joystick_1(JOYSTICK_1_PIN_VRX,JOYSTICK_1_PIN_VRY,JOYSTICK_1_PIN_SW);
Joystick joystick_2(JOYSTICK_2_PIN_VRX,JOYSTICK_2_PIN_VRY,JOYSTICK_2_PIN_SW);


// define vars for testing menu
const int timeout = 10000;       //define timeout of 10 sec
char menuOption = 0;
long time0;

// Setup the essentials for your circuit to work. It runs first every time your circuit is powered with electricity.
void setup() 
{
    // Setup Serial which is useful for debugging
    // Use the Serial Monitor to view printed messages
    Serial.begin(9600);
    while (!Serial) ; // wait for serial port to connect. Needed for native USB
    Serial.println("start");
    
    
    menuOption = menu();
    
}

// Main logic of your circuit. It defines the interaction between the components you selected. After setup, it runs over and over again, in an eternal loop.
void loop() 
{
    
    
    if(menuOption == '1') {
    // PS2 X Y Axis Joystick Module #1 - Test Code
    // Read Joystick X,Y axis and press
    int joystick_1X =  joystick_1.getX();
    int joystick_1Y =  joystick_1.getY();
    int joystick_1SW =  joystick_1.getSW();
    Serial.print(F("X: ")); Serial.print(joystick_1X);
    Serial.print(F("\tY: ")); Serial.print(joystick_1Y);
    Serial.print(F("\tSW: ")); Serial.println(joystick_1SW);

    }
    else if(menuOption == '2') {
    // PS2 X Y Axis Joystick Module #2 - Test Code
    // Read Joystick X,Y axis and press
    int joystick_2X =  joystick_2.getX();
    int joystick_2Y =  joystick_2.getY();
    int joystick_2SW =  joystick_2.getSW();
    Serial.print(F("X: ")); Serial.print(joystick_2X);
    Serial.print(F("\tY: ")); Serial.print(joystick_2Y);
    Serial.print(F("\tSW: ")); Serial.println(joystick_2SW);

    }
    
    if (millis() - time0 > timeout)
    {
        menuOption = menu();
    }
    
}



// Menu function for selecting the components to be tested
// Follow serial monitor for instrcutions
char menu()
{

    Serial.println(F("\nWhich component would you like to test?"));
    Serial.println(F("(1) PS2 X Y Axis Joystick Module #1"));
    Serial.println(F("(2) PS2 X Y Axis Joystick Module #2"));
    Serial.println(F("(menu) send anything else or press on board reset button\n"));
    while (!Serial.available());

    // Read data from serial monitor if received
    while (Serial.available()) 
    {
        char c = Serial.read();
        if (isAlphaNumeric(c)) 
        {   
            
            if(c == '1') 
    			Serial.println(F("Now Testing PS2 X Y Axis Joystick Module #1"));
    		else if(c == '2') 
    			Serial.println(F("Now Testing PS2 X Y Axis Joystick Module #2"));
            else
            {
                Serial.println(F("illegal input!"));
                return 0;
            }
            time0 = millis();
            return c;
        }
    }
}