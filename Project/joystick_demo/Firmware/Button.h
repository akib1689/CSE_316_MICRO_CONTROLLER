#ifndef _BUTTON_H_
#define _BUTTON_H_


//button  class:
class Button {
  public:
    Button(const int pin) : m_pin(pin) {
        
    }
    //initialize button instance
    void init(){
        pinMode(m_pin,INPUT);
    }
    //Read button state - without debounce
    bool read(){
        return digitalRead(m_pin);
    }
    //return True on both button events, Press or Release
    bool onChange(){
        bool reading = read();
        if(reading != m_lastButtonState) {
            m_lastDebounceTime = millis();
            m_pressFlag = true;
        }
        if (millis() - m_lastDebounceTime > m_debounceDelay) {
            if (m_pressFlag) {
                m_pressFlag = false;
                m_lastButtonState = reading;
                return true;
            }
        }
        m_lastButtonState = reading;
        return false;
    }
    //return True only on Press
    bool onPress(){
        bool reading = read();
        if(reading == HIGH && m_lastButtonState == LOW) {
            m_lastDebounceTime = millis();
            m_pressFlag = true;
        }

        if (millis() - m_lastDebounceTime > m_debounceDelay) {
            if (m_pressFlag) {
                m_pressFlag = false;
                m_lastButtonState = reading;
                return true;
            }
        }

        m_lastButtonState = reading;
        return false;
    }
    //return True only on Release
    bool onRelease(){
        bool reading = read();
        if(reading == LOW && m_lastButtonState == HIGH) {
            m_lastDebounceTime = millis();
            m_pressFlag = true;
        }

        if (millis() - m_lastDebounceTime > m_debounceDelay) {
            if (m_pressFlag) {
                m_pressFlag = false;
                m_lastButtonState = reading;
                return true;
            }
        }

        m_lastButtonState = reading;
        return false;
    }
    

  private:
    const int m_pin;
    bool m_lastButtonState; //state variables
    long m_lastDebounceTime = 0;  // the last time the output pin was toggled
    const int m_debounceDelay = 50;    // the debounce time; increase if the output flickers
    bool m_pressFlag = 0;

};

#endif //_BUTTON_H_