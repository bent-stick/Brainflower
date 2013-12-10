// BENT-STICK's brain_grapher modification 2013 november
class Brainflower
{
   Blip[] blips = new Blip[8];
   Blap[] blaps = new Blap[8];
   Colorpicker colorer;
   int x, y, w, h, bg, fade, flowermap;
   float speed;
   boolean drawFlower, drawOutline;
   
   Brainflower(int _x, int _y, int _w, int _h, int _bg, int _fade, float _speed, boolean _flower, boolean _drawOutline)
   {
      x = _x;
      y = _y;
      w = _w;
      h = _h;
      bg = _bg;
      fade = _fade;
      speed = _speed;
      drawFlower = _flower;
      flowermap = drawFlower ? 0 : -1;
      drawOutline = _drawOutline;
   }
   
   void setup()
   {
      colorer = new Colorpicker(160);
   
      float radius = 0.4 * h; 
      float radiusBand = radius / 5.0;
   
      for (int i = 0; i < 8; i++)
      {
//         float thisRadius = radius - (i * radiusBand);
         color thisColor = colorer.pickColor(8-i);
//         blips[i] = new Blip(thisRadius, radiusBand, thisColor);
         blips[i] = new Blip(radius, radiusBand, thisColor);
         blaps[i] = new Blap(radius, radiusBand, thisColor);
      }
//      fill(bg);
//      rect(x, y, w, h);
   }
   
   void draw()
   {
//      noStroke();
//      fill( bg, fade );
//      rect( x, y, w, h );
   
      for (int c = 0; c < (channels.length - 2); c++)
      {
         Channel thisChannel = channels[c];
         pushMatrix();
         translate(w/2, h/2);
         for (int i = 0; i < 8; i++)
         {
            Point thisPoint = new Point(0,0);
            for (int j = 0; j < thisChannel.points.size(); j++)
            {
               thisPoint = (Point)thisChannel.points.get(j);
            }
            float blipValue = map(thisPoint.value, 0, thisChannel.maxValue, flowermap, 1.5);
            int m = millis();
            if (((thisChannel.maxValue % (thisPoint.value + 1)) + 1) % ((m % 8) + 1) == 0)
               if (!drawOutline)
               blips[constrain(c,0,7)].drawBlip(speed/(c+2), blipValue, drawFlower);
               if (drawOutline)
               blaps[constrain(c,0,7)].drawBlap(speed/(c+2), blipValue, drawFlower);
         }
         popMatrix();
      }
//      if (blips[7].isFullRotation()) noLoop();
   }
}
