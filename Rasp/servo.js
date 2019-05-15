const Gpio = require('pigpio').Gpio;

const motor = new Gpio(4, {mode: Gpio.OUTPUT});
var open = false ;
let pulseWidth = 1000;
let increment = 100;

setInterval(() => {
  motor.servoWrite(pulseWidth);

  pulseWidth += increment;
  if (pulseWidth >= 2000 && open== false) {
    increment = -100;
  } else if (pulseWidth <= 1000 && open==true) {
    increment = 100;
  }
}, 1000);
