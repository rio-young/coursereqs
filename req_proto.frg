#lang forge

sig Course {
    prereqs: set Course
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
    no c: Course | c in c.^prereqs
    some c: Course | no c.prereqs
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

/* Rio
 * if the course has no prereqs or all prereqs have been taken
 */
pred preReqsMet[semester: Semester, course: Course] {
  course.prereqs in semester.courses_taken
}


/* Rio
 * Checks if a student can take a course after the given semester
 * A student can take a course if:
 *   They have not already taken the course
 *   They have taken all prereqs for the course
 */

pred canTake[semester: Semester, course: Course] {
    course not in semester.courses_taken
    -- SHJ I think no course.prereqs is already met in preResMet
    no course.prereqs or preReqsMet[semester, course] 
}

pred delta[s1, s2: Semester] {
  -- GUARD
  
  -- ACTION
  -- Courses taken changes
  s1.courses_taken != s2.courses_taken
  -- All the courses taken in s1 are stored in s2
  s1.courses_taken in s2.courses_taken
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

pred gradReqSatisfied[s: Semester] {
    GraduationReqs.courses in s.courses_taken
}

run {traces} for 4 Semester for {next is linear}