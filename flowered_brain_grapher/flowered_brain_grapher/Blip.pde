// BENT-STICK's brain_grapher modification 2013 november
public class Blip {
      // Constructors
   Blip(float _r, float _rb, color _c)
   {
      blipSetup(_r, _rb);
      setColor(_c);
   }

   // methods
   public void setColor(color _c)
   {
      c = _c;
   }
   
   public void drawBlip(float _speed, float _radiusMultiplier, boolean _drawFlower)
   {
      updateAngle(_speed);
      drawTriangle();
      updateRadius(_radiusMultiplier, _drawFlower);
   }

   public boolean isFullRotation()
   {
      if (angle > 2 * PI)
      {
         angle = 0.0;
         return true;
      }
      else
         return false;
   }
      
   public boolean isFullRotation(boolean _b)
   {
      if (angle <= 0.1)
         return true;
      else
         return false;
   }

   private float cosval, sinval, angle, radius, originalRadius, radiusBand;
   private int x, y, px, py;
   private color c = color(255);

   private void blipSetup(float _r, float _rb)
   {
      angle = 0.0;
      originalRadius = _r;
      radius = originalRadius;
      radiusBand = _rb;
   }
   private void computeNewPosition(float _cos, float _sin)
   {
      px = x;
      py = y;
      x = int(_cos * radius);
      y = int(_sin * radius);
   }

   private void drawTriangleBasic(color _c)
   {
      noFill();
      stroke(red(_c), green(_c), blue(_c), alpha(_c) * 0.5);
      strokeWeight(1);
      strokeCap(SQUARE);
      line(0, 0, x, y);

//      ellipseMode(CENTER);
//      ellipse(0,0,x*2,x*2);

//      strokeWeight(1);
//      if (count % 14 == 0)
//         beginShape(QUAD_STRIP);
//      vertex(px, py);
//      vertex(x, y);
//      if (count % 20 == 0)
//         endShape();
   }

   private void drawTriangle()
   {
      computeNewPosition(cosval, sinval);
      drawTriangleBasic(c);
   }
      
   private void updateAngle(float _speed)
   {
      sinval = sin(angle);
      cosval = cos(angle);
      angle += _speed;
   }

   private void updateRadius(float _radiusMultiplier, boolean _drawFlower)
   {
      if (_drawFlower)
         radius = originalRadius * _radiusMultiplier;
      else
         radius = originalRadius + _radiusMultiplier * radiusBand;
   }
}
