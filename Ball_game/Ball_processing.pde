import processing.serial.*;

Serial myPort;  // Create object from Serial class
int emgValue = 0;  // Store EMG value from Arduino

float ballX = 50;
float ballY = 50;
float ballSize = 50;
float ballSpeedX = 5;
float ballSpeedY = 5;

boolean emgControl = false;  // Flag to enable EMG control

void setup() {
  size(500, 500);
  smooth();
  noStroke();
  fill(255, 0, 0);
  
  // Start serial communication with Arduino
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(255);
  
  // Draw the ball
  ellipse(ballX, ballY, ballSize, ballSize);
  
  // Update the ball position
  updateBallPosition();
  
  // Bounce the ball off the walls
  if (ballX > width - ballSize / 2 || ballX < ballSize / 2) {
    ballSpeedX = -ballSpeedX;
  }
  if (ballY > height - ballSize / 2 || ballY < ballSize / 2) {
    ballSpeedY = -ballSpeedY;
  }
  ballX += ballSpeedX;
  ballY += ballSpeedY;
}

void keyPressed() {
  // If 'r' is pressed, reset the ball position
  if (key == 'r') {
    ballX = width / 2;
    ballY = height / 2;
  }
  
  // If 's' is pressed, toggle EMG control mode
  if (key == 's') {
    if (emgControl) {
      emgControl = false;
      println("EMG control mode disabled");
    } else {
      emgControl = true;
      println("EMG control mode enabled");
    }
  }
}

void serialEvent(Serial myPort) {
  // Read the incoming EMG value
  String val = myPort.readStringUntil('\n');
  if (val != null) {
    emgValue = int(val.trim());
    println(emgValue);
  }
}

void updateBallPosition() {
  // Update the ball position based on EMG value
  if (emgControl) {
    // Map the EMG value to the ball speed
    float ballSpeed = map(emgValue, 0, 1023, 0, 20);
    if (ballSpeed > 0) {
      ballSpeedX = ballSpeed;
    } else {
      ballSpeedX = -ballSpeed;
    }
  } else {
    // Use arrow keys to move the ball
    if (keyPressed && keyCode == LEFT) {
      ballSpeedX = -5;
    } else if (keyPressed && keyCode == RIGHT) {
      ballSpeedX = 5;
    }
  }
}
