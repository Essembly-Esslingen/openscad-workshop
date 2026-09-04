/*
makerspace workshop 2023-09-02
author: andimoto
*/
$fn=80;

/* [box dimensions] */
innerBoxX = 100;
innerBoxY = 100;
innerBoxZ = 60;

wallThickness = 5;
bottomThickness = 5;

edgeRadius = 5;

/* [ other parameters ] */
extra = 0.01;

module box()
{
  difference()
  {
    translate([edgeRadius,edgeRadius,0])
    minkowski()
    {
      cube([innerBoxX+wallThickness*2-edgeRadius*2,
        innerBoxY+wallThickness*2-edgeRadius*2,
        innerBoxZ+bottomThickness-extra*2]);
      cylinder(r=edgeRadius, h=extra);
    }

    translate([edgeRadius+wallThickness,edgeRadius+wallThickness,bottomThickness+extra])
    minkowski()
    {
      cube([innerBoxX-edgeRadius*2,
        innerBoxY-edgeRadius*2,
        innerBoxZ-extra*2]);
      cylinder(r=edgeRadius, h=extra);
    }
  }
}

box();
