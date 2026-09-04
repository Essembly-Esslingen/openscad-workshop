/*
makerspace workshop 2023-09-02
author: andimoto
*/
$fn=80;

/* [box dimensions] */
innerBoxX = 100;
innerBoxY = 100;
innerBoxZ = 60;

wallThickness = 6;
bottomThickness = 5;

edgeRadius = 5;

useInserts = false;


/* [lid] */
lidThickness = 5;
lidClearance = 0.4;
lidFixZ = 1;

/* [screw dimensions] */
screwDia = 3;
screwDiaTolerance = 0.2;
screwLen = 12;
screwHeadDia = 6;
screwHeadThick = 3;
insertDia = 4.4;

/* [simulation preferences] */
showFullAssembly = false;
showAnimation1 = false;
showAnimation2 = false;
showBox = false;
showLid = false;
showLogo = false;

/* [other parameters] */
extra = 0.01;

// screw placement
screwPlacement = [
[wallThickness-1,wallThickness-1],
[innerBoxX+wallThickness+1,wallThickness-1],
[innerBoxX+wallThickness+1,innerBoxY+wallThickness+1],
[wallThickness-1,innerBoxY+wallThickness+1]
];


if(showFullAssembly==true)
{
  assembly();
}

if(showAnimation1 == true)
{
  animation1();
}

if(showAnimation2 == true)
{
  animation2();
}

if(showBox == true)
{
  box();
}

if(showLid == true)
{
  lid();
}

if(showLogo == true)
{
  logo();
}


module assembly()
{
  box();

  translate([0,0,bottomThickness+innerBoxZ])
  translate([0,0,lidThickness])
  mirror([0,0,1])
  lid();

  translate([0,0,innerBoxZ+bottomThickness+lidFixZ])
  translate([0,0,screwHeadThick+0.2])
  mirror([0,0,1])
  color("Silver")
  screws(screwDia,screwHeadDia,screwHeadThick);
}


module animation1()
{
  box();

  translate([0,0,bottomThickness+innerBoxZ+20-$t*20])
  translate([0,0,lidThickness])
  mirror([0,0,1])
  lid();

}


module animation2()
{
  box();

  translate([0,0,bottomThickness+innerBoxZ])
  translate([0,0,lidThickness])
  mirror([0,0,1])
  lid();

  translate([0,0,20-$t*20])
  translate([0,0,innerBoxZ+bottomThickness+lidFixZ+1])
  translate([0,0,screwHeadThick+0.2])
  mirror([0,0,1])
  color("Silver")
  screws(screwDia,screwHeadDia,screwHeadThick);
}

function getInsert() =  (useInserts==false) ? (screwDia+screwDiaTolerance) : insertDia;

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

    translate([0,0,innerBoxZ+bottomThickness])
    translate([0,0,screwHeadThick+0.3])
    mirror([0,0,1])
    screws(getInsert(),screwHeadDia,screwHeadThick);
    /* screws(screwDia+screwDiaTolerance,screwHeadDia,screwHeadThick); */
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

    translate([0,0,-extra])
    screws(screwDia+screwDiaTolerance*2,screwHeadDia,screwHeadThick+0.5);

    #translate([(innerBoxX+wallThickness+edgeRadius)/2,(innerBoxY+wallThickness+edgeRadius)/2,-extra])
    mirror([1,0,0])
    logo(height=1,sizeX=innerBoxX, sizeY=innerBoxY);
  }
}


/* screws(screwDia+screwDiaTolerance,screwHeadDia,screwHeadThick+0.5); */
module screws(screwD = 3, screwHeadD = 6, screwHeadThickness = 3)
{
  for (p=screwPlacement) {
    translate([p[0],p[1],0])
    screw(screwD, screwHeadD, screwHeadThickness);
  }

}

/* screw(screwD=3, screwHeadD = 6, screwHeadThickness =3); */
module screw(screwD = 3, screwHeadD = 6, screwHeadThickness = 3)
{
  union()
  {
    /* head */
    cylinder(r=screwHeadD/2, h=screwHeadThickness);
    /* screw */
    translate([0,0,screwHeadThickness+0.2])
    cylinder(r = screwD/2, h=screwLen);

    translate([0,0,screwHeadThickness])
    intersection()
    {
      cylinder(r=screwHeadD/2,h=0.3);
      translate([0,0,0.1])
        cube([screwHeadD,screwD,0.3],center=true);
    }
  }
}

/* logo(height=5, sizeX=50, sizeY=50); */
module logo(height=10, sizeX=10, sizeY=10)
{
  translate([-sizeX/2,-sizeY/2,0])
  translate([-0.74,-0.74,0])  resize([sizeX,sizeY,0])
  linear_extrude(height=height)
  import("logo-offen.svg");
}
