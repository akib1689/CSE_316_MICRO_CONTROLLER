#ifndef JOYSTICK_H
#define JOYSTICK_H

#include "AnalogReader.h"
#include "Button.h"

class Joystick 
{
	public:
        Joystick(int pinX, int pinY, int pinSW) : m_pinX(pinX), m_pinY(pinY), m_pinSW(pinSW) {
            pinMode(m_pinX,INPUT);
            pinMode(m_pinY,INPUT);
            pinMode(m_pinSW,INPUT);
            
            joyX = new AnalogReader(m_pinX);
            joyY = new AnalogReader(m_pinY);
            joySW = new Button(m_pinSW);
        }
		//get X axis reading
		int getX(){
            return joyX->read();
        }
		//get Y axis reading
		int getY(){
            return joyY->read();
        }
		//return indication on joystick press
		//The joystick assembly button is '0' when not pressed, so we flip the button logic
		bool getSW(){
            return !joySW->read();
        }
		
	private:
		int m_pinX, m_pinY, m_pinSW;
		AnalogReader *joyX;
		AnalogReader *joyY;
		Button		 *joySW;
		

};
#endif //JOYSTICK