#lang forge

Course = `CS0111 + `CS0500 + `CS1040 + `CS1300 + `CS1340 + `CS1380 + `CS1430 +
         `CS1440 + `CS1470 + `CS0112 + `CS0150 + `CS0170 + `CS0410 + `CS1230 + 
         `CS1260 + `CS1270 + `CS1360 + `CS1460 + `CS1570 + 
         --Rio
         `CS1515 + `CS0200 + `CS0300 + `CS0220 + `CS0330 + `CS1310 +
         `CS1950S + `CS1330 + `CS1550 + `CS1660 + `CS1620 + `CS0330 +
         `CS0160 + `CS0180 + `CS0190 + `CS1670 + `CS1710 + `CS1800 +
         `CS1820 + `CS1810 + `CS1880 + `CS1950U + `CS1951A + `CS1951L + 
         `CS0320 + `CS1340 + `CS1951Z + `CS1420 + `CS1950F + `CS1952B +
         `CS1952Q + `CS1655 + `CS0450 + `CS1450 + `CS0530 + `CS0540 + 
         `CS1952X + `CS1952Y + `CS1952Z + `CS1510 + `CS0510 + `CS1010 + 
         `CS1600 + `CS1650 + `CS1680 + `CS1730 + `CS1760 + `CS1805 +
         `CS1810 + `CS1950N + `CS1951X + `CS1953A + `CS1870
//Prereqs for `CS1515: (CSCI 0200 or 0220) and (CSCI 0300, 0330, 1310, 1950S or 1330)
`CS1515.prerequisites = `CS0200 + `CS0220 +      
                        `CS0300 + `CS0330 + `CS1310 + `CS1950S + `CS1330
`CS1620.prerequisites = `CS1660

//Prereqs for `CS1660: (CSCI 0160, 0180, or 0190) and (CSCI 0300, 0330, 1310, or 1330)
`CS1660.prerequisites = `CS0160 + `CS0180 + `CS0190 +      
                        `CS0300 + `CS0330 + `CS1310 + `CS1330

//Prereqs for `CS 1670: `CSCI 0300, 0330, 1310, or 1330
`CS1660.prerequisites = `CS0300 + `CS0330 + `CS1310 + `CS1330

//Prereqs for `CS 1710:  `CSCI 0160, `CSCI 0180, `CSCI 0190, or `CSCI 0200. 
`CS1710.prerequisites = `CS0160 + `CS0180 + `CS0190 + `CS0200
`CS1820.prerequisites = `CS1810

//Prereqs for `CS1950U: (CSCI 0320, 1340, 0300, 1310 or 0330) and `CSCI 1230 
`CS1950U.prerequisites = `CS0320 + `CS1340 + `CS0300 + `CS1310 + `CS0330 + 
                         `CS1230

//Prereqs for `CS1951A: `CSCI 0160, `CSCI 0180, `CSCI 0190, or `CSCI 0200
`CS1951A.prerequisites = `CS0160 + `CS0180 + `CS0190 + `CS0200

//Prereqs for `CS1951L: `CSCI 0300, 0320, 1340, 0330, 1310, 1950S, 1330 
`CS1951L.prerequisites = `CS0300 + `CS0320 + `CS1340 + `CS0330 + `CS1310 + `CS1950S + `CS1330

//Prereqs for `CS1951Z: `CSCI 1420, 1950F
`CS1951Z.prerequisites = `CS1420 + `CS1950F

//Prereqs for `CS1952Q: (CSCI 0160, 0180, 0190 or 0200) and (CSCI 1450, 0450 or 1655) and (CSCI 0530 or 0540)
`CS1952Q.prerequisites = `CS0160 + `CS0180 + `CS0190 + `CS0200 +
                         `CS1450 + `CS0450 + `CS1655 +
                         `CS0530 + `CS0540

//Prereqs for 1952Y: `CSCI 0300, 1310, 0330
`CS1952Y.prerequisites = `CS0300 + `CS1310 + `CS0330

//Prereqs for `CS1510: `CSCI 0220 and (CSCI 0510 or 1010)
`CS1510.prerequisites = `CS0220 + 
                        `CS0510 + `CS1010

//Prereqs for 1570: `CSCI 0160, `CSCI 0180, or `CSCI 0190, and one of `CSCI 0220, `CSCI 1010, `CSCI 1450
`CS1570.prerequisites = `CS0160 + `CS0180 + `CS0190 + 
                        `CS0220 + `CS1010 + `CS1450

//Prereqs for 1600: `CSCI 0320, 1340, 0300, 0330, 1310, 1950S, 1330
`CS1600.prerequisites =  `CS0320 + `CS1340 + `CS0300 + `CS0330 + `CS1310 + `CS1950S + `CS1330

//Prereqs for 1650: 0330, 1670, 0300, 1310 
`CS1650.prerequisites = `CS0330 + `CS1670 + `CS0300 + `CS1310 

//Prereqs for 1680: `CSCI 0300, 0330, 1310, 1950S, 1330 
`CS1680.prerequisites = `CS0300 + `CS0330 + `CS1310 + `CS1950S + `CS1330 

//Prereqs for 1730: 0160, 0180, 0190, 0200
`CS1730.prerequisites = `CS0160 + `CS0180 + `CS0190 + `CS0200

`CS1760.prerequisites = `CS0330

//Prereqs for `CS1810: `CSCI 0160, `CSCI 0180 or `CSCI 0190, 
`CS1810.prerequisites = `CS0160 + `CS0180 + `CS0190 

//Prereqs for 1950N: `CSCI 0160, 0180, or 0190.
`CS1950N.prerequisites = `CS0160 + `CS0180 + `CS0190

`CS1951X.prerequisites = `CS1710

