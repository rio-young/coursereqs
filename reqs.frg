#lang forge
abstract sig Boolean {}
one sig True, False extends Boolean {}
/*
 * For every other course, the requirements are in conjuntive normal form:
 * (330 OR 300) AND (LINALG)
 */
sig EquivalentCourse {
    eq_courses: set Course
}
sig Course {
    prerequisites: set EquivalentCourse
}

sig Professor {
  courses: set Course,
  on_sabatical: one Boolean
}

// State Tracking
one sig Transcript {
    first: one Semester
}

one sig GraduationReqs {
    requirements: set Course
}

sig Semester {
    taking: set Course,
    courses_taken: set Course,
    next: lone Semester
}

pred wellformed_equivalent_courses {
    -- This is more of an optimization issue, but we don't want duplicates
    no disj e1, e2: EquivalentCourse | {
        e1.eq_courses = e2.eq_courses 
    }
}
pred wellformed_prereqs {
    all c: Course | {
      no c.prerequisites or
      (some c2: Course| {
        c2 in c.prerequisites.eq_courses
        not reachable[c, c2, prerequisites, eq_courses]
      })
    }
    some c: Course | no c.prerequisites
}

-- CS1570-CS1010 fails this
pred wellformed_prereqs_with_no_cycles {
    no c: Course | reachable[c, c, prerequisites, eq_courses]
}

pred wellformed_gradreqs {
    some GraduationReqs.requirements
}

pred wellformed_transcript {
    Transcript.first = Semester - Semester.next
}

pred wellformed_professors{
  all course: Course | some p: Professor | course in p.courses
}

pred wellformed {
    wellformed_professors
    wellformed_equivalent_courses
    wellformed_gradreqs
    wellformed_prereqs
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
}

/* Rio
 * if the course has no prerequisites or all prerequisites have been taken
 */
pred prerequisites_met[semester: Semester, course: Course] {
    all courseSet: course.prerequisites | {
        some (courseSet.eq_courses & semester.courses_taken)
    }
}

/* Rio
 * Checks if a student can take a course after the given semester
 * A student can take a course if:
 *   They have taken the intro if that's needed
 *   They have taken all prerequisites for the course
 */
pred can_take[semester: Semester, course: Course] {
    prerequisites_met[semester, course]
    some p: Professor | {
      course in p.courses => p.on_sabatical = False
    }
    course not in semester.courses_taken
    // course.requires_intro = True => introseq_satisfied[semester]
}

pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes; NOT NECESSARILY, could take no CS courses in a semester (e.g. study abroad)
    s1.courses_taken != s2.courses_taken


    s1.courses_taken in s2.courses_taken
    s1.taking = s2.courses_taken - s1.courses_taken

    all new_course: s2.taking | {
        can_take[s1, new_course]
    }
}

pred traces {
    init
    wellformed
    -- The original comment said that students should take any course they 
    -- have not already taken if they completed their grad reqs. This is 
    -- technically true, but it's also true for all semesters. Maybe I
    -- misunderstood something
    all s: Semester.next | delta[s.~next, s]

    -- Graduation requirement satisfied by the last semester
    some s: Semester | no s.next and gradreq_satisfied[s]

    -- No more than 5 courses can be taken in a single semester
    all s: Semester | #{s.taking} <= 5
}

pred gradreq_satisfied[s: Semester] {
    GraduationReqs.requirements in (s.courses_taken + s.taking)
}

inst allcourses {
  Course = `CS0111 + `CS0500 + `CS1040 + `CS1300 + `CS1380 + `CS1430 + `CS1411 + 
          `CS1440 + `CS1470 + `CS0112 + `CS0150 + `CS0170 + `CS0410 + `CS1230 +
          `CS1260 + `CS1270 + `CS1360 + `CS1460 + `CS1570 + 
          --Rio
          `CS1515 + `CS0200 + `CS0300 + `CS0220 + `CS0330 + `CS1310 +
          `CS1950S + `CS1330 + `CS1550 + `CS1660 + `CS1620 + `CS0330 +
           `CS0190 + `CS1670 + `CS1710 + `CS1800 + `CS1870 + `CS1760 + 
          `CS1820 + `CS1810 + `CS1880 + `CS1950U + `CS1951A + `CS1951L + 
          `CS0320 + `CS1340 + `CS1951Z + `CS1420 + `CS1950F + `CS1952B +
          `CS1952Q  + `CS1450 + `CS0530  + `CS1950N + `CS1951X +`CS1805 +
           `CS1952Y + `CS1952Z + `CS1510  + `CS1010 + `CS1680 + `CS1730 + 
          `CS1600 + `CS1650 
          

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
              `JamesHTompkin
  
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

test expect {
  grad1: {
    traces
    some s: Semester | gradreq_satisfied[s]
  } for grad_reqs1 is sat
  grad2: {
    traces
    some s: Semester | gradreq_satisfied[s]
  } for grad_reqs2 is sat
}

// run {traces} for exactly 8 Semester for {
//     #Int = 6
//     allcourses
//     next is linear
// }
