#lang forge

sig Course {
    prerequisites: set Course
}

one sig Transcript {
    first: one Semester
}

one sig GraduationReqs {
    courses: set Course
}

sig Semester {
    courses_taken: set Course,
    next: lone Semester
}

pred wellformed_prereqs {
    -- no circular prereqs
    no c: Course | c in c.^prerequisites
    some c: Course | no c.prerequisites
}

pred wellformed_gradreqs {
    some GraduationReqs.courses
}

pred wellformed_transcript {
    Transcript.first = Semester - Semester.next
}

pred wellformed {
    wellformed_gradreqs
    wellformed_prereqs
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
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
  course not in semester.courses_taken
}

//Michael
// Take an appropriate transition from one semester to the next
pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes
    s1.courses_taken != s2.courses_taken
    -- All the courses taken in s1 are stored in s2
    s1.courses_taken in s2.courses_taken

    all new_course: s2.courses_taken - s1.courses_taken | {
        canTake[s1, new_course]
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
    GraduationReqs.courses in s.courses_taken
}

run {traces} for 4 Semester for {next is linear}