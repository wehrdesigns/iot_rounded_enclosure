$fa = 1;
$fs = 0.4;
J = 0.001;

pcbW = 29;          //Width of pcb for esp32
pcbD = 52;          //Depth of pcb for esp32
pcbT = 1.5;           //Thickness of esp32 pcb
holeDw = 23;  //Distance from center to center of mounting holes across pcb width
holeDd = 47;  //Distance from center to center of mounting holes across pcb depth

RR = 5;         //Rounding Radius
wallT = 2;      //Wall Thickness
enclD = pcbD+2*wallT+1;     //Enclosure Depth
enclW = 60;     //Enclosure Width
enclH = 60;     //Enclosure Height
S = enclD*0.5;  //Depth to split the enclosure

pirR = 23*0.5;       //PIR Sensor cutout Radius

lightR = 5*0.5;   //light sensor Radius
lightH=2.5;         //light sensor height
leadW=1;            //light sensor lead width

ledR = 5.5*0.5;       //LED Radius

tabW = 10;      //Width of tabs for holding enclosure together

temphumW=15.5;      //Width of temperature/humidity sensor
temphumH=20.5;      //Height of temperature/humidity sensor
temphumV=10;         //Vertical offset of temperature/humidity sensor

pinR=1.3;                //pin Radius for pcb holder
pinH=6;                //pin Height
holdH=2;                //holder Height
holdW = pcbW+8;      //holder Width
holdD = pcbD;      //holder Depth

supH = 10;            //Support Height
supW = 6;           //Support Width
supD = enclD*0.6;      //Support Depth
supO = 2;            //Support Overlap

usbR=11*0.5;        //Radius of micro usb plug for round hole
usbW = usbR*0.65;   //Width of rectancular micro usb cutout
usbH=wallT+supH*0.5+pcbT+1.5+3;            //Height of center of plug measured from bottom
usbO=enclW*0.5;            //Offset of center of plug from side wall

pinW = 6;           //Width of pin used to hold sensors in place

depthF=0.3;      //light hole cutout location as fraction of enclosure depth

lighttubeD=8;        //Depth of light tube

tabR=0.2;   //Ridge Lock depth and width

pcbside = 7;
pcblockD = 30;     //how deep the lock reaches over the pcb
pcblockH = 13.5;     //height from outside bottom wall to bottom of the square lock

lightsensordepthF=0.3;      //cutout location as fraction of enclosure depth
blockW=lightR*2+6;     //support block Width
blockH=lightH+3;      //support block Height

//pcb holder
pcbCompD = pcbD-8;   //pcb Component Depth
pcbCompW = pcbW-8;   //pcb Component Width
pcbCompH = 5;   //pcb Component Height
cutT = 0.4;       //cutout Tolerance
//PinsOrRails = "pins"
PinsOrRails = "rails";
railcutoutZoff = 4;   //Z offset from holder to center of rail cutout
pcbholderrailH = railcutoutZoff+pcbT+2;  //
pcbholderrailW = 1.5;
pcbholderrailCD = 0.4; //Cutout Depth for groove that pcb will slide into
//28x49 W:1, D:3
//25.7x49
reducepcbW = 29-25.7;     //for mounting a smaller pcb width
reducepcbD = 3;     //for mounting a smaller pcb depth

//wall mount
wall_mountD = 0.25*enclD+2*wallT;  //Depth
earW = 15;
tol = 0.2;

module enclosure_front(){
    difference(){
        //the enclosure
        minkowski(){
            translate([RR,RR,RR])
            sphere(RR);
            cube([enclD-2*RR,enclW-2*RR,enclH-2*RR]);
        }
        //create the interior of the cube
        minkowski(){
            translate([wallT,wallT,wallT])
            translate([RR,RR,RR])
            sphere(RR);
            cube([enclD-2*RR-2*wallT,enclW-2*RR-2*wallT,enclH-2*RR-2*wallT]);
        }

        //remove the back of the cube to create the front
        translate([S,0-J,0-J])
        cube([S,enclW+2*J,enclH+2*J]);

        //hole for pir sensor
        pir_sensor_cutout();
        //hole for led
//        led_cutout();
        light_sensor_cutout();
    }
    light_sensor_support();
    pcb_top_lock();
}

module enclosure_back(){
    difference(){
        //the enclosure
        minkowski(){
            translate([RR,RR,RR])
            sphere(RR);
            cube([enclD-2*RR,enclW-2*RR,enclH-2*RR]);
        }
        //create the interior of the cube
        minkowski(){
            translate([wallT,wallT,wallT])
            translate([RR,RR,RR])
            sphere(RR);
            cube([enclD-2*RR-2*wallT,enclW-2*RR-2*wallT,enclH-2*RR-2*wallT]);
        }

        //remove the front of the cube to create the front
        translate([0,0-J,0-J])
        cube([S,enclW+2*J,enclH+2*J]);

        //cutout for temperature/humidity sensor
        temphum_sensor_cutout();
        //cutout for micro-usb plug
        //microusb_cutout_round();
        microusb_cutout_rectangular();
        //hole for light sensor
        //light_sensor_cutout();
    }
    //slide the pcb_holder into the groove on these supports
    pcb_supports();
    //light_sensor_tube();
    closure_tabs();
}

module temphum_sensor_cutout(){
    translate([enclD-2*wallT-J,0.5*enclW-0.5*temphumH,enclH*0.5-0.5*temphumW+temphumV])
    cube([2*wallT+2*J,temphumH,temphumW]);
}

module microusb_cutout_round(){
    translate([enclD-2*wallT-J,enclW*0.5,usbH])
    rotate([0,90,0])
    cylinder(2*wallT+2*J,usbR,usbR);
}

module microusb_cutout_rectangular(){
    translate([enclD-2*wallT-J,(enclW-2*usbW)*0.5,usbH+usbW*0.5])
    minkowski(){
        sphere(usbW*0.5);
        {rotate([0,90,0])
        linear_extrude(2*wallT+2*J)
        square([usbW,2*usbW]);}
    }
}
module pir_sensor_cutout(){
    //hole for a round PIR sensor
    translate([0-J,(enclW)*0.5,(enclH)*0.6])
    rotate([0,90,0])
    cylinder(2*wallT+2*J,pirR,pirR);
}

module light_sensor_cutout(){
    //hole in the enclosure for the light sensor
    //top cutout
    translate([enclD*depthF,enclW*0.5,enclH-2*wallT-J])
    //back cutout
//    rotate([0,90,0])
//    translate([-enclH*0.75,enclW*0.5,enclD-2*wallT+J])
    cylinder(2*wallT+2*J,lightR,lightR);
}
module light_sensor_tube(){
    //the light sensor can be recessed in this tube
    //top location
    //translate([enclD*0.7,enclW*0.5,enclH-D])
    //back location
    rotate([0,90,0])
    translate([-enclH*0.75,enclW*0.5,enclD-4*wallT-J])
    difference(){
        cylinder(lighttubeD+2*J,wallT+lightR,wallT+lightR);
        translate([0,0,0-J])
        cylinder(lighttubeD+4*J,lightR,lightR);
    }
}
module led_cutout(){
    //hole for an LED   
    translate([0-J,(enclW)*0.75,(enclH)*0.35])
    rotate([0,90,0])
    cylinder(2*wallT+2*J,ledR,ledR);
    
    translate([0-J,(enclW)*0.25,(enclH)*0.35])
    rotate([0,90,0])
    cylinder(2*wallT+2*J,ledR,ledR);
}
module closure_tabs(){
    //friction tab to hold the front and back of the enclosure together
//    //bottom tab
//    translate([enclD*0.5-W*0.5,1.5*RR,wallT-J])
//    cube([W,enclD-3*RR,wallT]);
    //top tab
    translate([enclD*0.5-tabW*0.5,3*RR,enclH-2*wallT+J])
    cube([tabW,enclD-6*RR,wallT]);
    
    //right tab
    translate([enclD*0.5-tabW*0.5,wallT-J,3*RR])
    cube([tabW,wallT,enclD-6*RR]);
    //add a ridge lock to the tab
    translate([enclD*0.5-tabW*0.4,wallT-J-tabR,3*RR])
    cube([3*tabR,tabR,enclD-6*RR]);
    
    //left tab
    translate([enclD*0.5-tabW*0.5,enclW-2*wallT+J,3*RR])
    cube([tabW,wallT,enclD-6*RR]);
    //add a ridge lock to the tab
    translate([enclD*0.5-tabW*0.4,enclW-1*wallT-J,3*RR])
    cube([3*tabR,tabR,enclD-6*RR]);
}
module pcb_supports(){
    difference(){
        translate([enclD-supD-wallT,enclW*0.5-holdW*0.5-supW+supO,wallT-J]){
        cube([supD,supW,supH]);
        }
        pcb_holder();
    }
    
    difference(){
        translate([enclD-supD-wallT,enclW*0.5+holdW*0.5-supO,wallT-J]){
        cube([supD,supW,supH]);
        }
        pcb_holder();
    }
}

module pcb_top_lock(){
    //when the front and back of the enclosure are put together, this lock will extend over the pcb and keep it from falling off the pcb holder
    translate([0,wallT+enclD*0.5-pcbside*0.5,pcblockH+pcbside])
    rotate([0,90,0])
    linear_extrude(pcblockD)
    square([pcbside,pcbside]);
    
}
module light_sensor_support(){
//The light (cds) sensor will slide into this holder to be positioned under the light sensor cutout
    translate([RR*0.2,enclW*0.5,enclH-wallT+J])
    {
        difference(){
            //holder for light sensor
            translate([0,-blockW*0.5,-blockH])
            cube([enclD*lightsensordepthF+2*lightR-J,blockW,blockH]);
            //remove slot for light sensor
            translate([0,-lightR*2*0.5,-lightH])
            cube([enclD*lightsensordepthF+2*lightR,lightR*2,lightH]);
            //remove slot for leads
            translate([0,-leadW*0.5,-blockH-J])
            cube([enclD*lightsensordepthF+2*lightR,leadW,blockH+J]);
        }
    }
}
module pin(){
//print three pins to hold in place the temp/humidity sensor, the PIR sensor and the light sensor
    translate([0.5*enclD,wallT,0.5*enclH])
    cube([pinW,enclD-2*wallT,pinW]);    
}
module pcb_holder(){    
    //holds the pcb with pins - will be printed separately so that the pins can be printed easily
    translate([enclD-pcbD-wallT,enclW*0.5-holdW*0.5-cutT*0.5,wallT-J+supH*0.5-cutT*0.5])
    union(){
        difference(){
            cube([holdD,holdW+cutT,holdH+cutT]);
            translate([(holdD-pcbCompD)*0.5,(holdW-pcbCompW)*0.5,-J])
            cube([pcbCompD,pcbCompW,pcbCompH]);
        }
        if (PinsOrRails == "pins"){
            //pins to hold pcb
            translate([(holdD-holeDd)*0.5,
                        (holdW-holeDw)*0.5,
                        holdH-J])
            cylinder(pinH,pinR,pinR);
                
            translate([holeDd+(holdD-holeDd)*0.5,
                        (holdW-holeDw)*0.5,
                        holdH-J])
            cylinder(pinH,pinR,pinR);
                
            translate([(holdD-holeDd)*0.5,
                        holeDw+(holdW-holeDw)*0.5,
                        holdH-J])
            cylinder(pinH,pinR,pinR);
                
            translate([holeDd+(holdD-holeDd)*0.5,
                        holeDw+(holdW-holeDw)*0.5,
                        holdH-J])
            cylinder(pinH,pinR,pinR);
        }
        if (PinsOrRails == "rails"){
            difference()
            {
                translate([0,0.5*(holdW-pcbW)-pcbholderrailW,holdH])
                cube([holdD,pcbW+2*pcbholderrailW,pcbholderrailH]);
                translate([-J,0.5*(holdW-pcbW+2*pcbholderrailCD+reducepcbW),holdH-J])
                cube([holdD+2*J,pcbW-2*pcbholderrailCD-reducepcbW,pcbholderrailH+2*J]);
                translate([-J+reducepcbD,0.5*(holdW-pcbW+reducepcbW),holdH+railcutoutZoff])
                cube([pcbD+2*J-reducepcbD,pcbW-reducepcbW,pcbT+0.5]);
            }
        }
    }
}

module wall_mount(){

    translate([0.5*enclD-0.5*wall_mountD,-wallT-0.125*RR,-wallT-0.125*RR])
    {
    difference()
    {
        cube([wall_mountD,enclW+2*wallT+0.25*RR,enclH+2*wallT+0.25*RR]);
        translate([-J,wallT+0.125*RR,wallT+0.125*RR])
        cube([wall_mountD+2*J,enclW+tol,enclH+tol]);
    }
        difference()
        {
        translate([0,-earW,0])
        cube([wall_mountD,enclH+2*wallT+0.25*RR+2*earW,wallT]);
        translate([0.5*wall_mountD,enclW+wallT+0.25*RR+0.75*earW,-5])
        cylinder(10,2,2);
        translate([0.5*wall_mountD,wallT+0.25*RR-0.75*earW,-5])
        cylinder(10,2,2);
        }
    }
}





//enclosure_front();
enclosure_back();

pcb_holder();

//pin();

//light_sensor_tube();
//light_sensor_cutout();
//led_cutout();

//wall_mount();