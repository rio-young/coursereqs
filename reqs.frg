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
    prerequisites: set Course
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

// Wellformed-ness checks
pred wellformed_introseqs {
    all sequence: IntroSequence | {
        // No intro course should require that the student have taken
        // the intro course
        all course: sequence.courses | course.requires_intro = False
        // At least one course in the sequence should not have any prereqs
        some course: sequence.courses | no course.prerequisites
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

// pred wellformed_prereqs {
//     -- no circular prereqs
//     no c: Course | c in c.^prerequisites
//     some c: Course | no c.prerequisites
// }

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
    wellformed_gradreqs
    wellformed_prereqs
    wellformed_transcript
    wellformed_equivalent_courses
    wellformed_introseqs
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

//maximum number of courses a student can take in each state (where a state represents a semester)
fun MAX_CLASSES: one Int { 5 }

//minimum number of courses a student can take in each state (where a state represents a semester)
fun MIN_CLASSES: one Int { 3 }

//Michael
//if the course has no prereqs return the course itself
//if the course has prereqs, return the furthest back course that has no prereqs
//can add some optimization (reach?)
  //ex: if there are multiple courses with the same prereq, prioritize that one
fun getHighestPrereq[semester: Semester, course: Course]: lone Course {
  -- If the course has no prereqs, return the course itself
  some course.prerequisites => {
    -- All the courses reachable from all the Course->Prereq relations in the model
    Course.^((Course->Course & Course->prerequisites) & (Course->Course))
  } else { course }
}

//Rio
//if the course has no prereqs or
//all prereqs have already been taken (perhaps we can do this recursively?)
pred preReqsMet[semester: Semester, course: Course] {
  // ASSUMING semester.courses_taken gives ALL classes previously taken not just those taken in that semester

  all c: Course | {
    c in course.prerequisites =>  c in semester.courses_taken
  }
}

//Rio
//Checks if a student can take a course after the given semester
// A student can take a course if:
  // They have not already taken the course
  // They have taken all prereqs for the course
  //will probably use preReqsMet
pred canTake[semester: Semester, course: Course] {
  no course.prerequisites or preReqsMet[semester, course]
  course.requires_intro = True => introseq_satisfied[semester]
  course not in semester.courses_taken
}

//Michael
// Take an appropriate transition from one semester to the next
pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes; NOT NECESSARILY, could take no CS courses in a semester (e.g. study abroad)
    s1.courses_taken != s2.courses_taken

    -- All the courses taken in s1 are stored in s2
    s1.courses_taken in s2.courses_taken
    s1.taking in s2.courses_taken
    
    -- Update courses taken
    s2.courses_taken = s1.taking + s1.courses_taken

    -- Verify that all new courses can be taken
    all new_course: s2.taking | {
      canTake[s2, new_course]
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
    all s: Semester | {#s.taking <= 5}
}

pred gradreq_satisfied[s: Semester] {
    GraduationReqs.requirements in (s.courses_taken + s.taking)
}

run {traces} for 4 Semester for {next is linear}