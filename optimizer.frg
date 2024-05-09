#lang forge

Course = `CS0111 + `CS0500 + `CS1040 + `CS1300 + `CS1380 + `CS1430 + `CS1411 + 
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
          `CS1950N + `CS1951X + `CS1953A + `CS1870

  EquivalentCourse = `EquivalentCourse1 + `EquivalentCourse2 + `EquivalentCourse3 + `EquivalentCourse4 +
                    `EquivalentCourse5 + `EquivalentCourse6 + `EquivalentCourse7 + `EquivalentCourse8 +
                    `EquivalentCourse9 + `EquivalentCourse10 + `EquivalentCourse11 + `EquivalentCourse12 +
                    `EquivalentCourse13 + `EquivalentCourse14 + `EquivalentCourse15 + `EquivalentCourse16 +
                    `EquivalentCourse17 + `EquivalentCourse18 + `EquivalentCourse19 + `EquivalentCourse20 +
                    `EquivalentCourse21 + `EquivalentCourse22 + `EquivalentCourse0

  `EquivalentCourse0.eq_courses = `CS0111
  `EquivalentCourse1.eq_courses = `CS0190 + `CS0111 + `CS0112 + `CS0170 + `CS0150
  `EquivalentCourse2.eq_courses = `CS0190 + `CS0200
  `EquivalentCourse3.eq_courses = `CS0200
  `EquivalentCourse4.eq_courses = `CS0220
  `EquivalentCourse5.eq_courses = `CS1570 + `CS0220 + `CS1550
  `EquivalentCourse6.eq_courses = `CS1340 + `CS0320
  `EquivalentCourse7.eq_courses = `CS1330 + `CS0220 + `CS0300 + `CS0320 + `CS0330 + `CS1310
  `EquivalentCourse8.eq_courses = `CS1330 + `CS1310 + `CS0330
  `EquivalentCourse9.eq_courses = `CS1330 + `CS0300 + `CS0330 + `CS0320 + `CS1340 + `CS1310
  `EquivalentCourse10.eq_courses = `CS1010 + `CS0220 + `CS1550
  `EquivalentCourse11.eq_courses = `CS0170 + `CS0190 + `CS0111 + `CS0150
  `EquivalentCourse12.eq_courses = `CS0190 + `CS0170 + `CS0200 + `CS0150
  `EquivalentCourse13.eq_courses = `CS1010
  `EquivalentCourse14.eq_courses = `CS0220 + `CS0200
  `EquivalentCourse15.eq_courses = `CS1330 + `CS1310 + `CS0300 + `CS0330
  `EquivalentCourse16.eq_courses = `CS1010 + `CS0220
  `EquivalentCourse17.eq_courses = `CS1330 + `CS0300 + `CS0330 + `CS0320 + `CS1310
  `EquivalentCourse18.eq_courses = `CS1330 + `CS0300 + `CS0330 + `CS1310 + `CS1670
  `EquivalentCourse19.eq_courses = `CS1810
  `EquivalentCourse20.eq_courses = `CS1230
  `EquivalentCourse21.eq_courses = `CS1710
  `EquivalentCourse22.eq_courses = `CS1420
  `CS0112.prerequisites = `EquivalentCourse0
  `CS0200.prerequisites = `EquivalentCourse1
  `CS0300.prerequisites = `EquivalentCourse2
  `CS0320.prerequisites = `EquivalentCourse2
  `CS0330.prerequisites = `EquivalentCourse2
  `CS0410.prerequisites = `EquivalentCourse3 + `EquivalentCourse4
  `CS0500.prerequisites = `EquivalentCourse4 + `EquivalentCourse2
  `CS1010.prerequisites = `EquivalentCourse5
  `CS1040.prerequisites = `EquivalentCourse2 + `EquivalentCourse6
  `CS1230.prerequisites = `EquivalentCourse2
  `CS1260.prerequisites = `EquivalentCourse7
  `CS1270.prerequisites = `EquivalentCourse8
  `CS1310.prerequisites = `EquivalentCourse2
  `CS1330.prerequisites = `EquivalentCourse2
  `CS1340.prerequisites = `EquivalentCourse2
  `CS1380.prerequisites = `EquivalentCourse9
  `CS1411.prerequisites = `EquivalentCourse3 + `EquivalentCourse4
  `CS1420.prerequisites = `EquivalentCourse2
  `CS1430.prerequisites = `EquivalentCourse2
  `CS1460.prerequisites = `EquivalentCourse2
  `CS1440.prerequisites = `EquivalentCourse10 + `EquivalentCourse11
  `CS1470.prerequisites = `EquivalentCourse12 + `EquivalentCourse4
  `CS1510.prerequisites = `EquivalentCourse4 + `EquivalentCourse13
  `CS1515.prerequisites = `EquivalentCourse14 + `EquivalentCourse15
  `CS1570.prerequisites = `EquivalentCourse2 + `EquivalentCourse16
  `CS1600.prerequisites = `EquivalentCourse17
  `CS1650.prerequisites = `EquivalentCourse18
  `CS1660.prerequisites = `EquivalentCourse2 + `EquivalentCourse15
  `CS1670.prerequisites = `EquivalentCourse15
  `CS1680.prerequisites = `EquivalentCourse15
  `CS1710.prerequisites = `EquivalentCourse2
  `CS1730.prerequisites = `EquivalentCourse2
  `CS1760.prerequisites = `EquivalentCourse15
  `CS1810.prerequisites = `EquivalentCourse2
  `CS1820.prerequisites = `EquivalentCourse19
  `CS1950N.prerequisites = `EquivalentCourse2
  `CS1950U.prerequisites = `EquivalentCourse9 + `EquivalentCourse20
  `CS1951A.prerequisites = `EquivalentCourse2
  `CS1951L.prerequisites = `EquivalentCourse9
  `CS1951X.prerequisites = `EquivalentCourse21
  `CS1951Z.prerequisites = `EquivalentCourse22
  `CS1952Q.prerequisites = `EquivalentCourse2
  `CS1952Y.prerequisites = `EquivalentCourse15



  //GRAD REQS
  `seriesA = `CS0150 + `CS0200
  `seriesB = `CS0170 + `CS0200
  `seriesC = `CS0190 
  `seriesD = `CS0111 + `CS0112 + `CS0200

// Seven advanced classes
//♦︎ One complete pathway (see ScB for pathways)	
// Requires two 1000-level courses as well as one-to-three intermediate courses
// ♦︎ Additional intermediate courses so that a total of three are taken with at least one in each of two different intermediate-course categories (see the ScB requirements for a listing of these categories)	
// ♦︎ One additional 1000-level course that is neither a core nor a related course for the pathways used above	
// ♦︎ Of the remaining two courses, at least one must be at the 1000-level or higher (i.e., one may be an intermediate course not otherwise used as part of the concentration). One course may be an approved 1000-level course from another department. Unless explicitly stated in a pathway, such non-CS courses may not be used as part of pathways.