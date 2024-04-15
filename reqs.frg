#lang forge/temporal

option max_tracelength 8
option min_tracelength 8

// AND relation between courses
// e.g. CS17 and CS200
sig Sequence {
  courses: set Course
}

// OR relation between courses
// e.g. CS300 or CS33, CS19 or (CS17 and CS200), CS22 or CS1010
sig EquivalenceClass {
  equiv: set Sequence
}

sig Course {
  // professor: one Professor,
  prerequisites: set EquivalenceClass
}

//reach
// sig Professor {
//   courses: set Course
// }

sig Transcript {
  first: one Semester, 
  next: pfunc Semester -> Semester
}

sig Semester {
  courses_taken: set Course,
  grad_req: set Course
}

//maximum number of courses a student can take in each state (where a state represents a semester)
fun MAX_CLASSES: one Int { 5 }

//minimum number of courses a student can take in each state (where a state represents a semester)
fun MIN_CLASSES: one Int { 3 }

//Seong-Heon
// there should be no loops in course prereqs
// There should be courses with no prereqs
pred wellformed_prereqs {}

//Seong-Heon
//should start having taken no coursees
pred init {}

//Michael
//if the course has no prereqs return the course itself
//if the course has prereqs, return the furthest back course that has no prereqs
//can add some optimization (reach?)
  //ex: if there are multiple courses with the same prereq, prioritize that one
fun getHighestPrereq[student: Student, course: Course]: lone Course {}

//Rio
//if the course has no prereqs or
//all prereqs have already been taken (perhaps we can do this recursively?)
pred preReqsMet[student: Student, course: Course] {}

//Rio
// A student can take a course if:
  // They have not already taken the course
  // They have taken all prereqs for the course
  //will probably use preReqsMet
pred canTake[student: Student, course: Course] {}

//Michael
// Take an appropriate transition from one semester to the next
pred semesterTransition[ s1, s2: Semester]

//Seong-Heon
// if the courses taken by a student matches all those in grad requirements they can:
  // take any courses that they have not already taken and that they can take
pred traces {}

//Seong-Heon
//checks if a student has taken all required courses
pred graduationRequirementReached {}
