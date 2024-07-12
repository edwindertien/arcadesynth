$fn = 40;
bottom = 2.5;
rod = 10;
bowdencase(rod);

translate([30, 0, 0])lid(9 + rod, 33, 2, 2);

module box(length, width, height, wall) {
  difference() {
    union() {
      difference() {
        union() {
          translate([-wall, 0, 0])cube([length + 2 * wall, width, height]);
          translate([0, -wall, 0])cube([length, width + 2 * wall, height]);
        }
        translate([0, 0, -0.1])cube([length, width, height + 0.2]);
      }
      translate([0, 0, 0])cylinder(d = 2 * wall, h = height);
      translate([length, 0, 0])cylinder(d = 2 * wall, h = height);
      translate([length, width, 0])cylinder(d = 2 * wall, h = height);
      translate([0, width, 0])cylinder(d = 2 * wall, h = height);
    }
    translate([0, 0, wall])cylinder(d = 1.7, h = height);
    translate([length, 0, wall])cylinder(d = 1.7, h = height);
    translate([length, width, wall])cylinder(d = 1.7, h = height);
    translate([0, width, wall])cylinder(d = 1.7, h = height);
  }
}



module lid(length, width, height, wall) {
  difference() {
    union() {
      translate([-wall, 0, 0])cube([length + 2 * wall, width, height]);
      translate([0, -wall, 0])cube([length, width + 2 * wall, height]);
      translate([0, 0, 0])cylinder(d = 2 * wall, h = height);
      translate([length, 0, 0])cylinder(d = 2 * wall, h = height);
      translate([length, width, 0])cylinder(d = 2 * wall, h = height);
      translate([0, width, 0])cylinder(d = 2 * wall, h = height);
      translate([0.1, 0.1, height])cube([length - 0.2, width - 0.2, 1]);
    }
    translate([wall, wall, height])cube([length - 2 * wall + 0.3, width - 2 * wall, 1.05]);
    translate([0, 0, height])cylinder(d = 2 * wall + 0.3, h = height);
    translate([length, 0, height])cylinder(d = 2 * wall + 0.3, h = height);
    translate([length, width, height])cylinder(d = 2 * wall + 0.3, h = height);
    translate([0, width, height])cylinder(d = 2 * wall + 0.3, h = height);

    translate([0, 0, -0.1])cylinder(d = 2 , h = height + 1);
    translate([length, 0, -0.1])cylinder(d = 2 , h = height + 1);
    translate([length, width, -0.1])cylinder(d = 2 , h = height + 1);
    translate([0, width, -0.1])cylinder(d = 2, h = height + 1);

    translate([0, 0, -0.1])cylinder(d1 = 3.5, d2 = 2 , h = 1.2);
    translate([length, 0, -0.1])cylinder(d1 = 3.5, d2 = 2 , h = 1.2);
    translate([length, width, -0.1])cylinder(d1 = 3.5, d2 = 2  , h = 1.2);
    translate([0, width, -0.1])cylinder(d1 = 3.5, d2 = 2 , h = 1.2);
  }
}


module bowdencase(rod) {
  difference() {
    union() {
      cube([9 + rod, 33, 2]);
      box( 9 + rod, 33, 13, 2);
      translate([6 + rod, 28, bottom + 4])rotate([270, 0, 0])cylinder(d = 6, h = 7);
      translate([3 + rod, 28, bottom])cube([6, 7, 4]);
    }
    translate([-4.25, 0, 0])servohole(d = 2);
    translate([6 + rod, 29, bottom + 4])rotate([270, 0, 0])cylinder(d = 2, h = 10);
    translate([6 + rod, 23, bottom + 4])rotate([270, 0, 0])cylinder(d = 1, h = 10);
    translate([6 + rod, 10, 0])cylinder(d = 2, h = 3);
  }
}


module servohole(d) {
  translate([4.25, 4.5, -1])cube([11.5, 24, d + 2]);
  translate([20 / 2, 2.5, -0.1])cylinder(d = 2, h = d + 0.2);
  translate([20 / 2, 2.5, d - 1])nutM2();
  translate([20 / 2, 33 - 2.5, -0.1])cylinder(d = 2, h = d + 0.2);
  translate([20 / 2, 33 - 2.5, d - 1])nutM2();
}


module nutM2() {
  difference() {
    union() {
      rotate([0, 0, 90])translate([-2, -1.1, 0])cube([4, 2.2, 1.5]);
      rotate([0, 0, 210])translate([-2, -1.1, 0])cube([4, 2.2, 1.5]);
      rotate([0, 0, 330])translate([-2, -1.1, 0])cube([4, 2.2, 1.5]);
    }
    difference() {
      translate([-3, -3, 0])cube([6, 6, 1.5]);
      cylinder(d = 4.32, h = 1.5);
    }
  }
}
