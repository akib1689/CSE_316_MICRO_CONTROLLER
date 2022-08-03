#ifndef _ANALOG_READER_H
#define _ANALOG_READER_H

class AnalogReader
{
	public:
		AnalogReader(const int pin) : m_pin(pin) {
            
        }
		int read(){
            return analogRead(m_pin);
        }
		
	private:
		const int m_pin;
};
#endif //_ANALOG_READER_H