// Main controller / model file for the the Processing Brain Grapher.

// See README.markdown for more info.
// See http://frontiernerds.com/brain-hack for a tutorial on getting started with the Arduino Brain Library and this Processing Brain Grapher.

// Latest source code is on https://github.com/kitschpatrol/Processing-Brain-Grapher
// Created by Eric Mika in Fall 2010, last update Spring 2012

// Modified by THE BENT STICK in November 2013 as Brainflower

import processing.serial.*;
import controlP5.*;

ControlP5 controlP5;
ControlFont font;

Serial serial;

Brainflower brainflower;
Brainflower brainCircle;

Channel[] channels = new Channel[11];
Monitor[] monitors = new Monitor[10];
//Graph graph;
ConnectionLight connectionLight;

int packetCount = 0;
int globalMax = 0;
int count = 0;
String scaleMode;
boolean play = true;

void setup() {
  // Set up window
  size(1024, 768);
  frameRate(20);
  smooth();
  background(222);
  frame.setTitle("Processing Brain Grapher");  

  // Set up serial connection
  println("Find your Arduino in the list below, note its [index]:\n");
  println(Serial.list());
  serial = new Serial(this, Serial.list()[0], 9600);	
  serial.bufferUntil(10);

  // Set up the ControlP5 knobs and dials
  controlP5 = new ControlP5(this);
  controlP5.setColorLabel(color(0));	
  controlP5.setColorBackground(color(0));
  controlP5.disableShortcuts();	
  controlP5.disableMouseWheel();
  controlP5.setMoveable(false);
  font = new ControlFont(createFont("DIN-MediumAlternate", 12), 12);

  color c1 = color(128, 0, 0),
        c2 = color(255, 0, 0),
        c3 = color(255, 128, 0),
        c4 = color(255, 255, 0),
        c5 = color(0, 200, 0),
        c6 = color(0, 200, 200),
        c7 = color(0, 0, 200),
        c8 = color(255, 0, 255);
  
  // Create the channel objects
  channels[0] = new Channel("Signal Quality", color(0), "");
  channels[1] = new Channel("Attention", color(100), "");
  channels[2] = new Channel("Meditation", color(50), "");
  channels[3] = new Channel("Delta", c1, "Dreamless Sleep");
  channels[4] = new Channel("Theta", c2, "Drowsy");
  channels[5] = new Channel("Low Alpha", c3, "Relaxed");
  channels[6] = new Channel("High Alpha", c4, "Relaxed");
  channels[7] = new Channel("Low Beta", c5, "Alert");
  channels[8] = new Channel("High Beta", c6, "Alert");
  channels[9] = new Channel("Low Gamma", c7, "Multi-sensory processing");
  channels[10] = new Channel("High Gamma", c8, "???");

  // Manual override for a couple of limits.
  channels[0].minValue = 0;
  channels[0].maxValue = 200;
  channels[1].minValue = 0;
  channels[1].maxValue = 100;
  channels[2].minValue = 0;
  channels[2].maxValue = 100;
  channels[0].allowGlobal = false;
  channels[1].allowGlobal = false;
  channels[2].allowGlobal = false;

  // Set up the monitors, skip the signal quality
  for (int i = 0; i < monitors.length; i++) {
    monitors[i] = new Monitor(channels[i + 1], i * (width / 10), 3 * height / 4, width / 10, height / 4);
  }

  monitors[monitors.length - 1].w += width % monitors.length;

  // Set up the graph
//  graph = new Graph(0, 0, width, height / 2);
  
  brainflower = new Brainflower(0, 0, width, 3 * height / 4, 232, 1, 0.0625, true, true);
  brainflower.setup();

  brainCircle = new Brainflower(0, 0, width, 3 * height / 4, 232, 1, 0.125, false, false);
  brainCircle.setup();

  // Set yup the connection light
  connectionLight = new ConnectionLight(width - 98, 10, 20);
}

void draw() {
  // Keep track of global maxima
  if (scaleMode == "Global" && (channels.length > 3)) {
    for (int i = 3; i < channels.length; i++) {
      if (channels[i].maxValue > globalMax) globalMax = channels[i].maxValue;
    }
  }

  // Clear the background
  //background(255);

  // Update and draw the main graph
//  graph.update();
//  graph.draw();

   // Update and draw Bent-stick's Brainflower
   brainCircle.draw();
   brainflower.draw();
   count++;
  // Update and draw the connection light
  connectionLight.update();
  connectionLight.draw();

  // Update and draw the monitors
  for (int i = 0; i < monitors.length; i++) {
    monitors[i].update();
    monitors[i].draw();
  }
  if (!play) noLoop();
}

void serialEvent(Serial p) {
  // Split incoming packet on commas
  // See https://github.com/kitschpatrol/Arduino-Brain-Library/blob/master/README for information on the CSV packet format
  String[] incomingValues = split(p.readString(), ',');

  // Verify that the packet looks legit
  if (incomingValues.length > 1) {
    packetCount++;

    // Wait till the third packet or so to start recording to avoid initialization garbage.
    if (packetCount > 3) {
      for (int i = 0; i < incomingValues.length; i++) {
        int newValue = Integer.parseInt(incomingValues[i].trim());

        // Zero the EEG power values if we don't have a signal.
        // Can be useful to leave them in for development.
        if ((Integer.parseInt(incomingValues[0]) == 200) && (i > 2)) newValue = 0;

        channels[i].addDataPoint(newValue);
      }
    }
  }
}

void keyPressed()
{
   if (key == 'P') 
   {
      if (play)
      {
         play = false;
         save("data/" + hour() + "-" + minute() + ".jpg");
      }
      else
      {
         play = true;
         loop();
      }
   }
   if (key == 'c')
   {
      background(255);
   }
   if (key == 'p')
      noLoop();
}

// Utilities

// Extend Processing's built-in map() function to support the Long datatype
long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

// Extend Processing's built-in constrain() function to support the Long datatype
long constrainLong(long value, long min_value, long max_value) {
  if (value > max_value) return max_value;
  if (value < min_value) return min_value;
  return value;
}
