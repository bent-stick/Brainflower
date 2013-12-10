// BENT-STICK's brain_grapher modification 2013 november
class Colorpicker
{
   public Colorpicker()
   {
      setColors(alpha);
   }
   public Colorpicker(int _a)
   {
      setColors(_a);
   }
   public color pickColor(int _n)
   {
      switch(_n)
      {
         case 1:
            return purple;
         case 2:
            return blue;
         case 3:
            return cyan;
         case 4:
            return green;
         case 5:
            return yellow;
         case 6:
            return orange;
         case 7:
            return red;
         case 8:
            return darkRed;
         default:
            return color(255);
      }
   }
   public void setAlpha(int _a)
   {
      setColors(_a);
   }
   private int alpha = 255;
   private color purple, blue, cyan, green, yellow, orange, red, darkRed;
   private void setColors(int _a)
   {
      purple   = color(255, 0, 255, _a);
      blue     = color(0, 0, 200, _a);
      cyan     = color(0, 200, 200, _a);
      green    = color(0, 200, 0, _a);
      yellow   = color(255, 255, 0, _a);
      orange   = color(255, 128, 0, _a);
      red      = color(255, 0, 0, _a);
      darkRed  = color(128, 0, 0, _a);
   }
}
