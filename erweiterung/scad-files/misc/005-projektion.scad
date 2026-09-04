/*
makerspace workshop 2023-09-02
author: andimoto
*/
$fn=80;


/* logo(); */
module logo()
{
  import("makerspace-box-006.stl", convexity=3);
}

projection(cut=true)
translate([0,0,-60])
modify();

module modify()
{
  difference() {
    logo();

    translate([55,-2,30])
    rotate([-90,0,0])
    cylinder(r=5,h=20);
  }

}
