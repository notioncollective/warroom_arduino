/*
  Trigger solenoids based on serial data
	
  Messages are recieved in 3-byte chunks, with a header, tag, and byte value.
*/


#define HEADER		'|' // header for message
#define WIN    'W' // tag identifying a win message
#define REP    'R' // message identifying republican win
#define DEM    'D' // message identifying democratic win
#define BOTH_ON 'B' // turn both solenoids on
#define BOTH_OFF 'O' // turn both solenoids off
#define MESSAGE_BYTES	3 // total bytes in a single message

// Time before solenoid released
const int releaseDelay = 200;


// Republicans on pin 4, Democrats on pin 9
const int solDigOutPin1 = 4;
const int solDigOutPin2 = 9;

void setup() { 
  Serial.begin(9600); 
  
  // For debug
  pinMode(13, OUTPUT); 
}

void loop() {
	
	// make sure we've recieved the entire packet
	if(Serial.available() >= MESSAGE_BYTES) {
		// check for the header
		if(Serial.read() == HEADER) {
			// grab the tag
			char tag = Serial.read();
			if(tag == WIN) {
				// set the value
				int value = Serial.read();
				Serial.print("WINNER: ");
				Serial.println(value);
				// display the value using LEDs
				triggerSolenoid(value);
			// for debugging
			} else if (tag == BOTH_ON) {
                          digitalWrite(solDigOutPin1, HIGH);
                          digitalWrite(solDigOutPin2, HIGH);
                          Serial.println('Engage both solenoids');
			} else if (tag == BOTH_OFF) {
                          digitalWrite(solDigOutPin1, LOW);
                          digitalWrite(solDigOutPin2, LOW);
                          Serial.println('Release both solenoids');
                        }
		}
	}

	delay(10);
}

// Trigger the solenoid indicated by the value
void triggerSolenoid(int value) {
  // 
  if(value == REP) {
    digitalWrite(solDigOutPin1, HIGH);
    digitalWrite(13, HIGH);
  } else if(value == DEM) {
    digitalWrite(solDigOutPin2, HIGH);
    digitalWrite(13, LOW);
  }
  delay(releaseDelay);
  digitalWrite(solDigOutPin2, LOW);
  digitalWrite(solDigOutPin1, LOW);
}
	

