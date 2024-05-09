#lang forge

abstract sig Boolean {}
one sig True extends Boolean {}
one sig False extends Boolean {}

/*
 * The intro sequence is unique in that unlike other courses, its requirements
 * are in disjunctive normal form:
 * (111 AND 200) OR (150 AND 200) OR (170 AND 200) OR (190)
 * Therefore, we need to special case checking for whether the intro
 * sequence is completed
 */
sig IntroSequence {
    courses: set Course
}

/*
 * For every other course, the requirements are in conjuntive normal form:
 * (330 OR 300) AND (LINALG)
 */
sig EquivalentCourse {
    eq_courses: set Course
}
sig Course {
    requires_intro: one Boolean,
    prerequisites: set EquivalentCourse
}

// State Tracking
one sig Transcript {
    first: one Semester
}

one sig GraduationReqs {
    requirements: set Course
}

sig Semester {
    courses_taken: set Course,
    next: lone Semester
}

// Wellformed-ness checks
pred wellformed_introseqs {
    all sequence: IntroSequence | {
        // No intro course should require that the student have taken
        // the intro course
        all course: sequence.courses | {
          course.requires_intro = False
          no course.prerequisites
        }
        // At least one course in the sequence should not have any prereqs
        // some course: sequence.courses | no course.prerequisites
    }

    -- This is more of an optimization issue, but we don't want duplicates
    no disj s1, s2: IntroSequence | {
        s1.courses = s2.courses
    }
}

pred wellformed_equivalent_courses {
    -- This is more of an optimization issue, but we don't want duplicates
    no disj e1, e2: EquivalentCourse | {
        e1.eq_courses = e2.eq_courses 
    }
}

pred wellformed_prereqs {
    no c: Course | reachable[c, c, prerequisites, eq_courses]
    some c: Course | no c.prerequisites
}

pred wellformed_gradreqs {
    some GraduationReqs.requirements
}

pred wellformed_transcript {
    Transcript.first = Semester - Semester.next
}

pred wellformed {
    wellformed_introseqs
    wellformed_equivalent_courses
    wellformed_gradreqs
    wellformed_prereqs
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
}

pred introseq_satisfied[semester: Semester] {
    some seq: IntroSequence | {
        // seq.courses in semester.courses_taken
        (seq.courses & semester.courses_taken) = seq.courses
    }
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
    course.requires_intro = True => introseq_satisfied[semester]
}

pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes
    s1.courses_taken != s2.courses_taken
    -- All the courses taken in s1 are stored in s2
    s1.courses_taken in s2.courses_taken

    all new_course: s2.courses_taken - s1.courses_taken | {
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
}

pred gradreq_satisfied[s: Semester] {
    GraduationReqs.requirements in s.courses_taken
}

inst allcourses {
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
}

inst grad_reqs1 {
  //add some gradreqs here
  allcourses
}

test expect {
  grad1: {
    some s: Semester | gradreq_satisfied[s]
  } for grad_reqs1 is sat
}

run {traces} for exactly 8 Semester, 20 Course for {next is linear}