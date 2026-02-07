/**
 *DuePrint3 configuration.
 */

#include <Arduino.h>
#include "SimpleFOC.h"
#include "SimpleFOCDrivers.h"
#include "SimpleDCMotor.h"

#define LED_PIN PC13
volatile uint32_t lastStepMicros = 0;
uint32_t lastBlinkMillis = 0;
bool ledState = false;

// DCMotor object
DCMotor motor = DCMotor();
// DCDriver object
// there are different types to choose from, please select the correct one
// that matches your motor driver hardware.
DCDriver2PWM driver = DCDriver2PWM(PA_15, PB_3);
// Sensor object

Encoder encoder = Encoder(PA_6, PA_5, 500); 
// interrupt routine intialisation
void doA(){encoder.handleA();}
void doB(){encoder.handleB();}

StepDirListener step_dir = StepDirListener(PA_1, PA_2, 1.00f/322.87);
// void onStep() { step_dir.handle(); }
void onStep() { 
  step_dir.handle(); 
  lastStepMicros = micros();  // record activity timestamp
}


// Commander object, used for serial control
Commander commander = Commander(Serial);
// motor control function - this is needed to link the incoming commands 
// to the motor object
void onMotor(char* cmd){ commander.motor(&motor, cmd); }

/**
 * Setup function, in which you should intialize sensor, driver and motor,
 * and the serial communications and commander object.
 * Before calling the init() methods of these objects you can set relevant
 * parameters on them. 
 */
void setup() {
  // to use serial control we have to initialize the serial port
  //pinMode(LED_BUILTIN, OUTPUT);
  Serial1.begin(115200); // init serial communication
  // wait for serial connection - doesn't work with all hardware setups
  // depending on your application, you may not want to wait
  // while (!Serial) {};   // wait for serial connection
  // enable debug output to the serial port
  SimpleFOCDebug::enable();

  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, HIGH); // OFF initially
  
  // enable/disable quadrature mode
  encoder.quadrature = Quadrature::ON;

  // basic driver setup - set power supply voltage
  driver.voltage_power_supply = 12.0f;
  // if you want, you can limit the voltage used by the driver.
  // This value has to be same as or lower than the power supply voltage.
  driver.voltage_limit = 12.0f;
  // Optionally set the PWM frequency.
  driver.pwm_frequency = 25000;
  // init driver
  driver.init();
  // init sensor
  encoder.init();
  encoder.enableInterrupts(doA, doB);
  // link driver to motor
  motor.linkDriver(&driver);
  // link sensor to motor
  motor.linkSensor(&encoder);

  // set a voltage limit on the motor, optional. The value set here
  // has to be lower than the power supply voltage.
  motor.voltage_limit = 12.0f;
  motor.velocity_limit = 5000.0f;
  // control type - for this example we use position mode.
  motor.controller = MotionControlType::angle;
  //motor.controller = MotionControlType::velocity;
  motor.torque_controller = TorqueControlType::voltage;
  // init motor
  motor.init();
  // set the PID parameters for velocity control. Velocity PID is the basis also
  // for position mode. If you have not yet tested the velocity mode we strongly
  // suggest you do this first, and find the PID parameters for that mode as
  // the initial values to use here. 
  // Please consult our documentation and forums for tips on PID tuning. The values
  // can be different depending on your PSU voltage, the driver, the sensor
  // and the motor used.
  motor.PID_velocity.P = 0.45f;
  motor.PID_velocity.I = 2.0f;
  motor.PID_velocity.D = 0.001f;
  // output ramp limits the rate of change of the velocity, e.g. limits the
  // accelleration.
  motor.PID_velocity.output_ramp = 2000.0f;
  // low pass filter time constant. higher values smooth the velocity measured
  // by the sensor, at the cost of latency and control responsiveness.
  // Generally speaking, the lower this value can be while still producing good
  // response, the better.
  motor.LPF_velocity.Tf = 0.05f;
  // angle P-controller P parameter setting. Normally this can
  // be set to a fairly high value.
  motor.P_angle.P = 15.0f;  
  // set the target velocity to 0, we use the commander to set it later
  motor.target = 0.0f;
  // enable motor
  motor.enable();
  // add the motor and its control function to the commander
  commander.add('M', onMotor, "dc motor");
  // enable monitoring on Serial port
  motor.useMonitoring(Serial);
  motor.monitor_variables = _MON_TARGET | _MON_VEL | _MON_ANGLE;
  //motor.monitor_start_char = 'M';
  //motor.monitor_end_char = 'M';
  commander.verbose = VerboseMode::machine_readable;

  step_dir.init();
  step_dir.enableInterrupt(onStep);
  step_dir.attach(&motor.target);

  Serial.println("Initialization complete.");

}




void loop() {
  // call motor.move() once per iteration, ideally at a rate of 1kHz or more.
  // rates of more than 10kHz might need a delay, as the sensor may not be able to
  // update quickly enough (depends on sensor)
  motor.move(); // target position can be set via commander input

  // call commander.run() once per loop iteration, it will process incoming commands
  commander.run();

  // --- LED activity indicator ---
  uint32_t now = millis();
  static bool active = false;

  // Active if steps occurred within last 200 ms
  if (micros() - lastStepMicros < 200000) {
    active = true;
  } else {
    active = false;
  }

  // Blink LED every 500 ms while active
  if (active && (now - lastBlinkMillis > 500)) {
    lastBlinkMillis = now;
    ledState = !ledState;
    digitalWrite(LED_PIN, ledState ? LOW : HIGH); // inverted LED logic
  }
  else if (!active) {
    digitalWrite(LED_PIN, HIGH); // LED off when idle
  }

  // call motor.monitor() once per loop iteration, it will print the motor state
  //motor.monitor();
  //Serial.print(motor.shaft_angle);
  //Serial.print("\t");
  //Serial.println(motor.shaft_velocity);
  //encoder.update();
  // display the angle and the angular velocity to the terminal
  //Serial.print(encoder.getAngle());
  //Serial.print("\t");
  //Serial.println(encoder.getVelocity());
  //digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  //delay(100);                      // wait for a second
  //digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW
  //delay(100);                      // wait for a second
}