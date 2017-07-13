/**
* ARTISTIC INTERVENTION PROJECT FOR STS 490
*  Written by BAIRD WORKMAN
*  WebSocketServer code by Florian Shulz
*
* This is a creative coding assignment. The objective was to use our personal, targeted ad words downloaded from Facebook
*  in order to create an artistic intervention respresentation of Facebook's process of our subjectification.
*    Yes I know that was a lot of -tion words. Basically our targeted ad words create a "subjectification" of us: 
*    it creates a unique person based on the ad words. For example, my ad words included a lot of politically radical
*    words like Communism, Socialism, Ideology, etc. It also included several mentions of the Beach Boys. Based on these,
*    Facebook's subjectification of me is a Baird Workman who is a radically leftist Beach Boys fan. 
*  I tried to create a program that reflected this. The result is somewhat similar to the old point & click mystery games
*  where you're armed with only a flashlight. However, my program isn't really a *game* per se. There are no real objectives.
*  Users can explore my subjectivized room, and certain things will cause a reaction when clicked on. There is a companion 
* program to this one: a simple HTML file that utilizes Google Chrome's voice recognition API that will allow the user to say 
*  commands to the program while it is running. Certain words will trigger sound files. The words in question are hidden around
*  the room. 
*
*  If you do not already have the HTML file needed to use the speech recognition software, I have added the code to the bottom 
*   of this file. You're welcome. Just paste it into a text file and name it "index.html." Use the command "python -m SimpleHTTPServer" while in the
*   same working directory as the HTML file. Then open up Google Chrome (Chromium doesn't work as of me writing this) and go to
*   127.0.0.1:8000. The console of the running processing application should say: client connected. 
*/

import ddf.minim.*;
import muthesius.net.*;
import org.webbitserver.*;

WebSocketP5 socket;

Minim minim;
AudioPlayer player;
PImage img;
String vin;

/** Room vars */
int room;
int lastRoom;

/** IMAGES */
PImage spiderPic;
PImage compyPic;
PImage gumPic;

/**CONSTANTS */
final int FRONT = 0;
final int DESK = 1;
final int NIXON = 2;
final int BOTTLES = 3;
final int MARX = 4;
final int BACK = 5;
final int BOOKS = 6;
final int FLOOR = 7;
final int FACE = 8;
final int TOOL = 9;

/** Booleans */
boolean vp; // is voice playing?
boolean mc; // has message changed?
boolean onClose;
boolean fruitSalad;

/** Potato vars */
int potxpos[];
int potypos[];

/** Rectangle buttons */
Rectangle marx;
Rectangle desk;
Rectangle nixon;
Rectangle bottles;
Rectangle books;
Rectangle left;
Rectangle right;
Rectangle bottom;
Rectangle spider;
Rectangle face; 
Rectangle compy;
Rectangle tool;
Rectangle gum;

void setup() {
  socket = new WebSocketP5(this,8080);
  minim = new Minim(this);
  size(750, 422);
  rectMode(CENTER);
  vin = "";
  img = loadImage("frontroomrsMED.jpg");
  img.loadPixels();
  loadPixels();
  
  spiderPic = loadImage("spiderad.png");
  spiderPic.loadPixels();
  
  compyPic = loadImage("hpdesk.jpg");
  compyPic.loadPixels();
  
  gumPic = loadImage("5gumad.png");
  gumPic.loadPixels();
  
  vp = false;
  mc = false;
  onClose = false;
  fruitSalad = false;
  room = FRONT;
  lastRoom = room;
  marx = new Rectangle(110, 70, 250, 160); // MARX & VNS
  desk = new Rectangle(40, 230, 350, 360 ); // DESK COORDS 
  nixon = new Rectangle(450, 30, 532, 145); // NIXON POSTER COORDS 
  bottles = new Rectangle(40, 170, 350, 220); // BOTTLES COORDS
  books = new Rectangle(227, 188, 405, 255); // BOOKS COORDS
  left = new Rectangle(0, 0, 35, 422); // LEFT RECT COORDS
  right = new Rectangle(715, 0, 750, 422); // RIGHT RECT COORDS
  spider = new Rectangle(266, 293, 434, 384); // SPIDER COORDS
  bottom = new Rectangle(0, 392, 750, 422); // BOTTOM RECT COORDS
  face = new Rectangle(385, 57, 661, 290); // FACE COORDS
  compy = new Rectangle(256, 131, 490, 265); // COMPY COORDS
  tool = new Rectangle(461, 207, 582, 242); // TOOL COORDS
  gum = new Rectangle(412, 200, 512, 278); // GUM COORDS
  left.setColor(255, 255, 255, 20);
  right.setColor(255, 255, 255, 20);
}

void draw() {
  
  
  // HANDLE EACH AREA CLICK
  if (room == FRONT) {
    if (beenClicked(desk)) {
      img = loadImage("desk.jpg");
      img.loadPixels();
      loadPixels();
      room = DESK;
      lastRoom = FRONT;
      onClose = true;
    } else if (beenClicked(marx)) {
      img = loadImage("marx.jpg");
      img.loadPixels();
      loadPixels();
      room = MARX;
      lastRoom = FRONT;
      onClose = true;
    } else if (beenClicked(nixon)) {
      img = loadImage("nixon.jpg");
      img.loadPixels();
      loadPixels();
      room = NIXON;
      lastRoom = FRONT;
      onClose = true;
    } else if (beenClicked(bottles)) {
      img = loadImage("bottles.jpg");
      img.loadPixels();
      loadPixels();
      room = BOTTLES;
      lastRoom = FRONT;
      onClose = true;
    } else if (beenClicked(left) || beenClicked(right)) {
      img = loadImage("backroomMED.jpg");
      img.loadPixels();
      loadPixels();
      room = BACK;
      lastRoom = FRONT;
    } else if (beenClicked(bottom)) {
      img = loadImage("floorMED.jpg");
      img.loadPixels();
      loadPixels();
      room = FLOOR;
      lastRoom = FRONT;
    }
  } else if (room == BACK) {
    if (beenClicked(left) || beenClicked(right)) {
      img = loadImage("frontroomrsMED.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = BACK;
      room = FRONT;
    } else if (beenClicked(bottom)) {
      img = loadImage("floorMED.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = BACK;
      room = FLOOR;
    } else if (beenClicked(books)) {
      img = loadImage("closebooks.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = BACK;
      room = BOOKS;
      onClose = true;
    } else if (beenClicked(tool)) {
      img = loadImage("tools.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = BACK;
      room = TOOL;
      onClose = true;
    }
  } else if (room == FLOOR) {
    if (beenClicked(left)) {
      img = loadImage("frontroomrsMED.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = FLOOR;
      room = FRONT;
    } else if (beenClicked(right)) {
      img = loadImage("backroomMED.jpg");
      img.loadPixels();
      loadPixels();
      lastRoom = FLOOR;
      room = BACK;
    } else if (beenClicked(face)) {
      img = loadImage("floorCU.jpg");
      img.loadPixels();
      loadPixels();
      room = FACE;
      lastRoom = FLOOR;
      onClose = true;
    }
  }
  
  if (onClose && mousePressed && mouseButton == RIGHT) {
      if (lastRoom == FRONT) {
        img = loadImage("frontroomrsMED.jpg");
      } else if (lastRoom == BACK) {
        img = loadImage("backroomMED.jpg");
      } else if (lastRoom == FLOOR) {
        img = loadImage("floorMED.jpg");
      }
      img.loadPixels();
      loadPixels();
      onClose = false;
      int llrm = room;
      room = lastRoom;
      lastRoom = llrm;
  }
  
  if (vin.equalsIgnoreCase("communism") && mc) {
    mc = false;
    if (vp) {
      player.pause();
    }
    vp = true;
    println("welcome to russia");
    playSong("National Anthem of USSR.mp3", -10); 
  }
  
  if (vin.equalsIgnoreCase("hot potato") && mc) {
    mc = false;
    if (vp) {
      player.pause();
    }
    vp = true;
    println("lets DANCE");
    playSong("Hot Potato.mp3", 5);
  }
  
  if (vin.equalsIgnoreCase("safari") && mc) {
    mc = false;
    if (vp) {
      player.pause();
    }
    vp = true;
    println("catch a ~~~~~~~~~~~~~wavveeee~~~~~~~~");
    playSong("Surfin Safari.mp3", -5);
  }
  
  if (vin.equalsIgnoreCase("shut up") && vp) {
    player.pause();
    println("well excuse you");
    vp = false;
  }
  
  colorImage();
  updatePixels();
  rectMode(CORNERS);
  fill(100, 100, 100, 100);
  //println(mouseX + ", " + mouseY); //DEBUGGING / DEV Tool 
  if (!onClose) {
    //marx.display();
    //nixon.display();
    //desk.display();
    //bottles.display();
    left.display();
    right.display();
    
  } 
  if (room == BOOKS) {
    if (beenClicked(spider)) {
      image(spiderPic, 200, 0, 396, 422);
    }
  }
  if (room == DESK) {
    if (beenClicked(compy)) {
      image(compyPic, 265, 140);
    }
  }
  
  if (room == BOTTLES) {
    if (beenClicked(gum)) {
      image(gumPic, 265, 0, 301, 422);
    }
  }
  //println("room= " + room);
}

void playSong(String name, float volume) {
  player = minim.loadFile(name);
  player.setGain(volume);
  player.play();
  
}

boolean beenClicked(Rectangle r) {
  if (mouseX > r.x1 && mouseX < r.x2 && mouseY > r.y1 && mouseY < r.y2 && mousePressed && mouseButton == LEFT) {return true;}
  return false;
  
}
void colorImage() {
for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      // Get the R,G,B values from image
      float r,g,b;
      r = red (img.pixels[loc]);
      g = green (img.pixels[loc]);
      b = blue (img.pixels[loc]);
      // Calculate an amount to change brightness based on proximity to the mouse
      float maxdist = 100;//dist(0,0,width,height);
      float d = dist(x, y, mouseX, mouseY);
      float adjustbrightness = 255*(maxdist-d)/maxdist;
      float adjustredness = map(mouseX, width, 0, 0, 255);
      float adjustblueness = map(mouseX, 0, width, 0, 255);
      r += adjustbrightness;
      r += adjustredness;
      g += adjustbrightness;
      b += adjustbrightness;
      b += adjustblueness;
      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      // Make a new color and set pixel in the window
      //color c = color(r, g, b);
      int c = color(r);
      pixels[y*width + x] = color(r, g, b);
    }
  }
}
class Rectangle {
  
  int x1, y1, x2, y2;
  int r, g, b, a;
  Rectangle(int x1, int y1, int x2, int y2) {
      this.x1 = x1;
      this.x2 = x2;
      this.y1 = y1;
      this.y2 = y2;
      a = 100;
      b = 100;
      g = 100;
      r = 100;
  }
  
  void setColor(int r, int g, int b, int a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  void display() {
    rectMode(CORNERS);
    stroke(r, g, b, a);
    fill(r, g, b, a);
    rect(x1, y1, x2, y2);
  }
    
}
  
/** THE FOLLOWING CODE WAS WRITTEN BY FLORIAN SHULZ */
void stop(){
  socket.stop();
}

void websocketOnMessage(WebSocketConnection con, String msg){
  
  println(msg);
  vin = msg.trim();
  //println(vin);
  if (msg.contains("hello")) println("Yay!");
  mc = true;
}

void websocketOnOpen(WebSocketConnection con){
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con){
  println("A client left");
}
