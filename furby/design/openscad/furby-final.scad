// Furby face in modular synth
$fn = 50;           // rendering segements
ball_diam = 22.4;   // eye diameter
ball_wall = 0.8;    // eyeball wall thickness
pupillary = 30;     // distance between pupils
axisdist = 22;      // distance between two shafts
angle = 0.2;        // angle of section between eyes and beak
lidangle = 0;      // opening of eyelids: 0..70
beakangle = 30;     // opening of the beak: 0..30
clearance = 0;    // joint clearance for print in place, for face only


//base();
translate([pupillary,0,0])rotate([lidangle,0,180])eyelids();
//beakbottom();
//tongue();
//synth();

module eyelids(){
    color("grey")difference(){
        union(){
            eyecap();
            translate([(pupillary - 8) / 2, 0, 0])difference(){
                rotate([0, 90, 0])cylinder(d = 8.3, h = 8);
                translate([0, -1.5, 0])cube([8, 3, 10]);
            }
            translate([pupillary, 0, 0])eyecap();
           
   //       translate([5,-8,-1])rotate([0,90,0])cylinder(d=4,h=20);
            
            rotate([-40,0,0])translate([-13,0,0]){
                hull(){
                    rotate([0,90,0])cylinder(d=4,h=2);
                    translate([0,0,-10])rotate([0,90,0])cylinder(d=4,h=2);
                
            }
        }

        }
        
        translate([pupillary/2-2,-8,-5])rotate([0,90,0])cylinder(d=1.6,h=2);
        translate([(pupillary - 8) / 2, 0, 0]){
            translate([-0.01, 0, 0])rotate([0, 90, 0])cylinder(d = 3, h = 9);
            translate([-0.01, -1.5, -4.5])cube([2, 3, 4.5]);
            translate([8 - 1.99, -1.5, -4.5])cube([2, 3, 4.5]);

        }
        translate([pupillary, 0, 0])sphere(d = ball_diam + 1);
        translate([0, 0, 0])sphere(d = ball_diam + 1);
        
        rotate([-40,0,0])translate([-13,0,0]){
                    translate([0,0,-10])rotate([0,90,0])cylinder(d=2,h=2);
                
            }
    }
}

module plate_cut(){
projection(cut=false){
plate();
}
}

module plate(){
difference(){
modularplate(11,3); 
translate([17.5+5.08/2,100,-0.01])cylinder(d=32,h=10);

translate([17.5+5.08/2+pupillary,100,-0.01])cylinder(d=32,h=10);
translate([17.5+5.08/2+pupillary/2,100-22,-0.01])cylinder(d=30,h=10);

// sockets    
translate([10.52, 22.098, -0.01])cylinder(d=8, h=4);  
translate([10.52+16.29, 22.098, -0.01])cylinder(d=8, h=4);      
translate([10.52+16.29+16.256, 22.098, -0.01])cylinder(d=8, h=4);
translate([10.52+16.29+16.256+16.256, 22.098, -0.01])cylinder(d=8, h=4);

// potentiomters
    translate([10.3321,38.6004,-0.01])cylinder(d=7,h=4);
     translate([10.3321+16.256,38.6004,-0.01])cylinder(d=7,h=4);
    translate([10.3321+16.256+16.256,38.6004,-0.01])cylinder(d=7,h=4);
// encoder
  translate([10.414,53.0981,-0.01])cylinder(d=7,h=4);
// display
  translate([26.9240,51.4604,-0.01])cube([ 21.4884,5.689,4]);   
}
}

  
module vacuummold(){
hull(){
    cube([70,60,3]);
    translate([17.5+5.08/2+pupillary,40,-0.01])cylinder(d=30,h=10);
    translate([17.5+5.08/2,40,-0.01])cylinder(d=30,h=10);
    translate([17.5+5.08/2+pupillary/2,40-22,-0.01])cylinder(d=27,h=17);
}
    //translate([17.5+5.08/2,40,7.02])base();      // the 3D printed 
}


module synth(){
modularplate(11,3);                            // the aluminum base plate
translate([17.5+5.08/2,100,7.02])faceassembly();      // the 3D printed furby face
translate([19,32,0])display();                 // SSD1306 OLED display
translate([55,38,2])rotate([0,0,90*sin($t*360)])knob("red");               // standard d-shaft knob
translate([10,38,2])rotate([0,0,90*sin($t*360)])knob("red");
translate([55,60,2])rotate([0,0,90*sin($t*360)])knob("blue");
translate([10,60,2])rotate([0,0,90*sin($t*360)])knob("blue");
translate([10,20,2])jack();                    // standard 3.5mm jack socket
translate([25,20,2])jack();
translate([40,20,2])jack();
translate([55,20,2])jack();
}

module knob(color){
    color("grey"){
    cylinder(h=3, d1=15.8, d2 = 14.8);
    translate([0,0,3])cylinder(h=1.8,d1=14.8,d2=11.7);
        difference(){
            translate([0,0,3+1.8])cylinder(h=11,d1=11.7,d2=9.8);
            for(i=[0:40:360])rotate([0,0,i])translate([11.7/2,0,3+1.8])rotate([0,-3,0])cylinder(d=1.4,h=14);
    }
}
    color(color)translate([0,0,3+1.8+11])cylinder(h=0.5,d1=7.6,d2=7);
}

module jack(){
   color("black")
   difference(){
       cylinder(d=6.5,h=2);
       cylinder(d=5,h=3);
   }
   color("white")
   difference(){
       cylinder(d=4.7,h=2,2);
       cylinder(d=3.5,h=3);
   }
   }
module display(){
    color("darkblue")
    cube([27,11.5,3]);
}
module modularplate(units,thickness){
    a = 7.5;
    b = 3.0;
    h = 128.5;
    hole = 2.5;
    color("silver")
    difference(){
        cube([2*a+units*5.08,h,thickness]);   
        translate([a,b,-0.01])cylinder(d=hole,h=thickness+0.5);
        translate([a,h-b,-0.01])cylinder(d=hole,h=thickness+0.5);
        translate([a+units*5.08,b,-0.01])cylinder(d=hole,h=thickness+0.5);
        translate([a+units*5.08,h-b,-0.01])cylinder(d=hole,h=thickness+0.5);
    }
}
module faceassembly(){
    translate([pupillary, 0, 0])rotate([0, 0, 180])eye_unit();
    translate([pupillary, 0, 0])rotate([35+lidangle*cos($t*360), 0, 180])eyelids();
    base();
    translate([-pupillary/2-1.5, 0, 0])shaft(63);
    translate([0, -axisdist, 9])shaft(29.5);
    translate([pupillary/2,-axisdist,9])rotate([15+beakangle*sin($t*360),0,0])beaktop();
    translate([pupillary/2,-axisdist,9])rotate([15+beakangle*cos($t*360),0,180])beakbottom();
    translate([pupillary/2,-axisdist,9])rotate([80,0,180])tongue();
    
}
// and now for all the parts (and sub-parts)
module tongue(){color("red"){
    difference(){
        cylinder(d=19,h=2);
        translate([-10,-10,-0.01])cube([20,13.3,3]);
    }
    difference(){union(){
    translate([-5.5,0,0])cube([11,4,2]);
    translate([-5.5,0,0])rotate([0,90,0])cylinder(d=5,h=11);
    }
    translate([-6,0,0])rotate([0,90,0])cylinder(d=2+clearance,h=12);
}}}
module beaktop(){
    color("gold")difference(){
        union(){
            difference(){
                union(){
                    difference(){
                        sphere(d = 23);
                        sphere(d = 21);
                        translate([-20, -20, -20])cube([40, 40, 20]); // half-sphere
                    }
                    cylinder(d = 23, h = 2); // base plate
                }
                translate([-20, 0, -0.01])cube([40, 20, 20]); // quarter-sphere;
                translate([-8.5+3.4, -3, -0.01])cube([10.2, 5, 3]); // mid chunk
            }
            translate([8.5-3.4, 0, 0])rotate([0, 90, 0])cylinder(d = 4.5, h = 3.2);
            translate([-8.5+0.2 , 0, 0])rotate([0, 90, 0])cylinder(d = 4.5, h = 3.2); //0.2 as 3D print tolerance
        }
        translate([-15, 0, 0])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 30); // drill
        translate([-15, 0, 0])rotate([0, 90, 0])cylinder(d = 5, h = 6.7); // drill
        translate([8.3, 0, 0])rotate([0, 90, 0])cylinder(d = 5, h = 6.7); // drill
    }
}


module beakbottom(){
    color("gold")difference(){
        union(){
            translate([-1,-9.5,-2.5])rotate([0,90,0])cylinder(d=4,h=2);
            translate([-1,-11.5,-2.5])cube([2,4,2.5]);
            difference(){
                union(){
                    difference(){
                        sphere(d = 23);
                        sphere(d = 21);
                        translate([-20, -20, -20])cube([40, 40, 20]); // half-sphere
                    }
                    cylinder(d = 23, h = 2); // base plate
                }
                translate([-20, 0, -0.01])cube([40, 20, 20]); // quarter-sphere;
                translate([-8.5, -3, -0.01])cube([17, 5, 3]); // quarter-sphere;
            }
            translate([8.5, 0, 0])rotate([0, 90, 0])cylinder(d = 4.5, h = 3.2);
            translate([-8.5 - 3.2, 0, 0])rotate([0, 90, 0])cylinder(d = 4.5, h = 3.2);
        }
        translate([-1,-9.5,-2.5])rotate([0,90,0])cylinder(d=1.6,h=2);
        translate([-15, 0, 0])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 30); // drill
    }
}
module base(){
    color("SlateGray"){
        socket();
        translate([pupillary, 0, 0])mirror([1, 0, 0])socket();
        beak();
    }
}

module socket(){
    difference(){
        union(){
            eyerim();
            translate([0, 0, 0])mirror([0, 1, -angle])eyerim();
            translate([0, 0, -5])difference(){
                union(){
                    translate([-27 / 2 - 2.5, -2.5, 0])cube([2.5, 5, 5]);
                    translate([-27 / 2 - 2.5, 0, 5])rotate([0, 90, 0])cylinder(d = 5, h = 2.5);
                }
                translate([-27 / 2 - 2.6, 0, 5])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 4);
            }
        }
    }

}
module eyerim(){
    translate([0, 0, -5]){ // to allign axes
        difference(){
            union(){
                difference(){
                    union(){
                        cylinder(d = 31, h = 5);
                        translate([0,0,0.5])cylinder(d = 32.5, h = 1.7);
                        translate([13, 0, 5])rotate([0, 90, 0])cylinder(d = 14, h = 4);
                    }
                    translate([0, 0, -0.01])cylinder(d = 28, h = 6);
                    translate([12.5, 0, 5])rotate([0, 90, 0])cylinder(d = 10, h = 5);
                    translate([12.5, -5, 4])rotate([0, 90, 0])cube([5, 10, 11]);

                    translate([-40, -40, -40])cube([80, 80, 40.01]);//cut off everything below ground  
                }

            }
            translate([-20, -28, 0])cube([40, 28, 30]);
            translate([-27 / 2 - 2.6, 0, 5])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 4);

        }
    }
}

module beak(){
    difference(){
        union(){
            translate([1, -axisdist, 9])rotate([0, 90, 0])cylinder(d = 5, h = 2.5);
            translate([26.5, -axisdist, 9])rotate([0, 90, 0])cylinder(d = 5, h = 2.5);
            translate([pupillary / 2, -axisdist, 9]) beakhalf();
            translate([pupillary / 2, -axisdist, 9]) mirror([0, 1, -angle])beakhalf();
        }
        translate([-40, -40, -40])cube([80, 80, 35]);//cut off everything below ground
        translate([-1, -axisdist, 9])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 34);

    }

}
module beakhalf(){
    translate([0, 0, -14]){
        difference(){
            difference(){
                union(){
                    cylinder(d = 27, h = 14);
                    cylinder(d = 30, h = 11);
                }
                translate([0, 0, -0.01])cylinder(d = 24, h = 15);
            }

            translate([-22, -2.7, 0])rotate([-11.5, 0, 0])cube([80, 28, 30]);// rotation and translation experimentally, in order to cut off enough..
        }
    }

}






module eyecap(){
    difference(){
        translate([0, 0, 0])sphere(d = ball_diam + 1 + 3);
        translate([-15, -15, -15])cube([30, 30, 12]);
        translate([0, 0, 0])sphere(d = ball_diam + 1);
        translate([-15, 0, 0])rotate([0, 90, 0])cylinder(d = 2, h = 30);
        translate([-15, 7, -11])rotate([50, 0, 0])cube([30, 30, 10]);
    }
}
module shaft(value){
    color("silver")
    rotate([0, 90, 0])cylinder(d = 2, h = value);
}

module eye_unit(){
    color("white")
    difference(){
        union(){
            rotate([0, 0, 180])eyeball();
            translate([pupillary, 0, 0])eyeball();
            translate([3.5, ball_diam / 2, -2])rotate([0, 180, 180])linkbar();
        }
        eyeball_cutout();
        translate([pupillary, 0, 0])eyeball_cutout();
    }

}

module eyeball(){
    difference(){
        union(){
            translate([0, 0, 0])sphere(d = ball_diam);
            translate([-12, 0, 0])rotate([0, 90, 0])cylinder(d = 5.6, h = 3);
        }

        translate([-15, -15, -11.8 + ball_diam / 2 - 30 - 2])cube([30, 30, 30]);
        translate([-15, 0, 0])rotate([0, 90, 0])cylinder(d = 2+clearance, h = 30);
        difference(){
            translate([0, 0, 0])sphere(d = ball_diam - ball_wall);
            translate([-15, -15, 6])cube([30, 30, 30]);
        }
        translate([-15, -1, -4])cube([10, 2, 4]);
    }
}

module eyeball_cutout(){
    difference(){
        translate([0, 0, 0])sphere(d = ball_diam - ball_wall);
        translate([-15, -15, 6])cube([30, 30, 30]);
    }
}

module linkbar(){
    difference(){
        cube([24, 5.5, 2.3]);
        translate([-5, 0, 2.3])rotate([-18, 0, 0])cube([40, 10, 2.3]);
        translate([10, 2.4, -1])cube([4, 5, 4]);
    }
}


module innershape(){
difference(){
eyeball();
    translate([0,0,7])cylinder(d1=4,d2=20,h=3);
    translate([0,0,9])cylinder(d=14,h=8.8);
}
}