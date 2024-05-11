#lang forge

open "reqs.frg"

inst allcourses {
    Course = `CS0111 + `CS0500 + `CS1040 + `CS1300 + `CS1380 + `CS1430 + `CS1411 + 
            `CS1440 + `CS1470 + `CS0112 + `CS0150 + `CS0170 + `CS0410 + `CS1230 +
            `CS1260 + `CS1270 + `CS1360 + `CS1460 + `CS1570 + `CS1515 + `CS0200 + 
            `CS0300 + `CS0220 + `CS0330 + `CS1310 + `CS1950S + `CS1330 + `CS1550 + 
            `CS1660 + `CS1620 + `CS0330 + `CS0190 + `CS1670 + `CS1710 + `CS1800 + 
            `CS1870 + `CS1760 + `CS1820 + `CS1810 + `CS1880 + `CS1950U + `CS1951A + 
            `CS1951L + `CS0320 + `CS1340 + `CS1951Z + `CS1420 + `CS1950F + `CS1952B +
            `CS1952Q  + `CS1450 + `CS0530  + `CS1950N + `CS1951X +`CS1805 + `CS1952X +
            `CS1952Y + `CS1952Z + `CS1510  + `CS1010 + `CS1680 + `CS1730 + `CS1953A +
            `CS1600 + `CS1650 + `CS1250
            

    EquivalentCourse = `EquivalentCourse1 + `EquivalentCourse2 + `EquivalentCourse3 + `EquivalentCourse4 +
                        `EquivalentCourse5 + `EquivalentCourse6 + `EquivalentCourse7 + `EquivalentCourse8 +
                        `EquivalentCourse9 + `EquivalentCourse10 + `EquivalentCourse11 + `EquivalentCourse12 +
                        `EquivalentCourse13 + `EquivalentCourse14 + `EquivalentCourse15 + `EquivalentCourse16 +
                        `EquivalentCourse17 + `EquivalentCourse18 + `EquivalentCourse19 + `EquivalentCourse20 +
                        `EquivalentCourse21 + `EquivalentCourse22 + `EquivalentCourse0

    Professor = `MildaZizyte + `PhilipKlein + `AnnaLysyanskaya + `VanessaCho + `NikosVasilakis + `SrinathSridhar + 
                `AmyGreenwald + `RitambharaSingh + `TimNelson + `AndriesvanDam + `DanielRitchie + `RobertLewis +
                `UgurCetintemel + `ErnestoZaldivar + `ElliePavlick + `LorenzoDeStefani + `PeihanMiao + `NicholasDeMarinis +
                `EliUpfal + `ShriramKrishnamurthi + `ThomasWDoeppner + `ErnestoZaldivar + `DeborahHurley + 
                `SorinIstrail + `BernardoPalazzi + `MauriceHerlihy + `SureshVenkatasubramanian + `StephenBach +
                `PedroFelzenszwalb + `JuliaNetter + `YuCheng + `NoraAyanian + `VasileiosKemerlis + `TimothyHEdgar + 
                `JamesHTompkin + `DianaFreed + `TimothyEdgar + `KathrynSpoehr
    
    `DianaFreed.courses = `CS1953A
    `TimothyEdgar.courses = `CS1952X
    `KathrynSpoehr.courses = `CS1250
    `MildaZizyte.courses = `CS0111 + `CS1952Y + `CS1600
    `PhilipKlein.courses = `CS0500 + `CS0530 + `CS0170
    `AnnaLysyanskaya.courses = `CS1040
    `VanessaCho.courses = `CS1300
    `NikosVasilakis.courses = `CS1380
    `SrinathSridhar.courses = `CS1430
    `AmyGreenwald.courses = `CS1411 + `CS0410 + `CS1440
    `RitambharaSingh.courses = `CS1470
    `TimNelson.courses = `CS0112 + `CS0320 + `CS1340 + `CS1710
    `AndriesvanDam.courses = `CS0150
    `DanielRitchie.courses = `CS1230 + `CS1950U
    `RobertLewis.courses = `CS1260 + `CS1951X + `CS0220
    `UgurCetintemel.courses = `CS1270 + `CS1950S
    `ErnestoZaldivar.courses = `CS1360 + `CS1800
    `ElliePavlick.courses = `CS1460
    `LorenzoDeStefani.courses = `CS1570 + `CS1010 + `CS1951A
    `PeihanMiao.courses = `CS1510 + `CS1515
    `NicholasDeMarinis.courses = `CS0200 + `CS0330 + `CS1330 + `CS0300 + `CS1680 + `CS1310 + `CS1660 + `CS1620
    `EliUpfal.courses = `CS1550 + `CS1450
    `ShriramKrishnamurthi.courses = `CS0190 + `CS1730
    `ThomasWDoeppner.courses = `CS1670 + `CS0330 
    `DeborahHurley.courses = `CS1870
    `SorinIstrail.courses = `CS1810 + `CS1820
    `BernardoPalazzi.courses = `CS1660 + `CS1880
    `MauriceHerlihy.courses = `CS1760 + `CS1951L
    `SureshVenkatasubramanian.courses = `CS1951Z
    `StephenBach.courses = `CS1420
    `PedroFelzenszwalb.courses = `CS1950F
    `JuliaNetter.courses = `CS1952B
    `YuCheng.courses = `CS1952Q
    `NoraAyanian.courses = `CS1952Z
    `VasileiosKemerlis.courses = `CS1650
    `TimothyHEdgar.courses = `CS1805
    `JamesHTompkin.courses = `CS1950N


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

    `CS0111.available_semesters = `Fall0 + `Spring0
    `CS0200.available_semesters = `Fall0 + `Spring0
    `CS0320.available_semesters = `Fall0 + `Spring0
    `CS1340.available_semesters = `Fall0 + `Spring0
    `CS1430.available_semesters = `Fall0 + `Spring0
    `CS0220.available_semesters = `Spring0
    `CS0300.available_semesters = `Spring0
    `CS0500.available_semesters = `Spring0
    `CS1040.available_semesters = `Spring0
    `CS1300.available_semesters = `Spring0
    `CS1310.available_semesters = `Spring0
    `CS1380.available_semesters = `Spring0
    `CS1420.available_semesters = `Spring0
    `CS1460.available_semesters = `Spring0
    `CS1440.available_semesters = `Spring0
    `CS1470.available_semesters = `Spring0
    `CS1515.available_semesters = `Spring0
    `CS1550.available_semesters = `Spring0
    `CS1660.available_semesters = `Spring0
    `CS1670.available_semesters = `Spring0
    `CS1710.available_semesters = `Spring0
    `CS1800.available_semesters = `Spring0
    `CS1820.available_semesters = `Spring0
    `CS1880.available_semesters = `Spring0
    `CS1950U.available_semesters = `Spring0
    `CS1951A.available_semesters = `Spring0
    `CS1951L.available_semesters = `Spring0
    `CS1952B.available_semesters = `Spring0
    `CS1952Q.available_semesters = `Spring0
    `CS1952X.available_semesters = `Spring0
    `CS1952Y.available_semesters = `Spring0
    `CS1952Z.available_semesters = `Spring0
    `CS0112.available_semesters = `Fall0
    `CS0150.available_semesters = `Fall0
    `CS0170.available_semesters = `Fall0
    `CS0190.available_semesters = `Fall0
    `CS0330.available_semesters = `Fall0
    `CS0410.available_semesters = `Fall0
    `CS1010.available_semesters = `Fall0
    `CS1230.available_semesters = `Fall0
    `CS1250.available_semesters = `Fall0
    `CS1260.available_semesters = `Fall0
    `CS1270.available_semesters = `Fall0
    `CS1330.available_semesters = `Fall0
    `CS1360.available_semesters = `Fall0
    `CS1411.available_semesters = `Fall0
    `CS1510.available_semesters = `Fall0
    `CS1570.available_semesters = `Fall0
    `CS1600.available_semesters = `Fall0
    `CS1650.available_semesters = `Fall0
    `CS1680.available_semesters = `Fall0
    `CS1730.available_semesters = `Fall0
    `CS1760.available_semesters = `Fall0
    `CS1805.available_semesters = `Fall0
    `CS1810.available_semesters = `Fall0
    `CS1870.available_semesters = `Fall0
    `CS1950N.available_semesters = `Fall0
    `CS1951X.available_semesters = `Fall0
    `CS1951Z.available_semesters = `Fall0
    `CS1953A.available_semesters = `Fall0
}

inst grad_reqs1 {
    //add some gradreqs here
    allcourses
    GraduationReqs = `gradreqs
    
    `gradreqs.requirements = `CS0150 + `CS0200 + //series a
                            //COMPUTER ARCHITECTURE pathway
                            `CS1952Y + `CS1440 + `CS0330 +
                            //Intermediate Classes
                            `CS1450 + `CS0320 +
                            //3 1000 level classes
                            `CS1950N + `CS1510 + `CS1870
}

inst grad_reqs2 {
    //add some gradreqs here
    allcourses
    GraduationReqs = `gradreqs

    `gradreqs.requirements = `CS0170 + `CS0200 + //series b
                            //SOFTWARE PRINCIPLES pathway
                            `CS1260 + `CS1270 + 
                            //Intermediate Classes
                            `CS0220 + `CS0320 + `CS0300 + 
                            //3 1000-2000 level classes
                            `CS1950U + `CS1570 + `CS1440
}

// test expect {
//   grad1: {
//     traces
//     some s: Semester | gradreq_satisfied[s]
//   } for grad_reqs1 is sat
//   grad2: {
//     traces
//     some s: Semester | gradreq_satisfied[s]
//   } for grad_reqs2 is sat
// }

-- Validate instance. Sometimes, our instance is the issue, not the model
test expect {
    all_courses_have_instructor: wellformed_professors for allcourses is sat
    all_courses_wellformed: wellformed_courses for allcourses is sat
}

run traces for exactly 8 Semester for {
    /* Any smaller bitwidth will lead to 
       all s: Semester | #{s.taking} <= 5 
       displaying unexpected behavior due to integer wrap-around */
    #Int = 6
    allcourses
    next is linear
}