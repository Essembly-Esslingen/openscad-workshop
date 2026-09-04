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

/* [lid] */
lidThickness = 5;
lidClearance = 0.4;
lidFixZ = 1;

/* [screw dimensions] */
screwDia = 3;
screwDiaTolerance = 0.2;
screwLen = 12;
screwHeadR = 6;


/* [other parameters] */
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

/* box(); */


module lid()
{
  difference()
  {
    union()
    {
      translate([edgeRadius,edgeRadius,0])
      minkowski()
      {
        cube([innerBoxX+wallThickness*2-edgeRadius*2,
          innerBoxY+wallThickness*2-edgeRadius*2,
          lidThickness-extra*2]);
        cylinder(r=edgeRadius, h=extra);
      }
      translate([edgeRadius+wallThickness+lidClearance,
        edgeRadius+wallThickness+lidClearance,0])
      minkowski()
      {
        cube([innerBoxX-lidClearance*2-edgeRadius*2,
          innerBoxY-lidClearance*2-edgeRadius*2,
          lidFixZ+lidThickness-extra*2]);
        cylinder(r=edgeRadius, h=extra);
      }
    } /* union */

    screws();

  }
}
/* lid(); */

module screws()
{

}



screw(screwD=3, screwHeadD = 6, screwHeadThickness =3);
module screw(screwD = 3, screwHeadD = 6, screwHeadThickness = 3)
{
  /* head */
  cylinder(r=screwHeadD/2, h=screwHeadThickness);
  /* screw */
  translate([0,0,screwHeadThickness+0.2])
  cylinder(r = screwD/2, h=screwLen);

  translate([0,0,screwHeadThickness])
  intersection()
  {
    cylinder(r=screwD,h=0.2);
    translate([0,0,0.1])
      cube([screwHeadD,screwD,0.2],center=true);
  }
}
