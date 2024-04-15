#lang forge/temporal

option max_tracelength 8
option min_tracelength 8

sig Class {
  // professor: one Professor,
  prerequisites: set Class
}

//reach
// sig Professor {
//   classes: set Class
// }

sig Transcript {
  first: one Semester, 
  next: pfunc Semester -> Semester
}

sig Semester {
  classes_taken: set Class,
  grad_req: set Class
}

//maximum number of classes a student can take in each state (where a state represents a semester)
fun MAX_CLASSES: one Int { 5 }

//minimum number of classes a student can take in each state (where a state represents a semester)
fun MIN_CLASSES: one Int { 3 }

//Seong-Heon
// there should be no loops in class prereqs
// There should be classes with no prereqs
pred wellformed_prereqs {}

//Seong-Heon
//should start having taken no classes
pred init {}

//Michael
//if the course has no prereqs return the class itself
//if the course has prereqs, return the furthest back class that has no prereqs
//can add some optimization (reach?)
  //ex: if there are multiple courses with the same prereq, prioritize that one
fun getHighestPrereq[student: Student, class: Class]: lone Class {}

//Rio
//if the course has no prereqs or
//all prereqs have already been taken (perhaps we can do this recursively?)
pred preReqsMet[student: Student, class: Class] {}

//Rio
// A student can take a class if:
  // They have not already taken the class
  // They have taken all prereqs for the class
  //will probably use preReqsMet
pred canTake[student: Student, class: Class] {}

//Michael
// Take an appropriate transition from one semester to the next
pred semesterTransition[ s1, s2: Semester]

//Seong-Heon
// if the classes taken by a student matches all those in grad requirements they can:
  // take any classes that they have not already taken and that they can take
pred traces {}

//Seong-Heon
//checks if a student has taken all required classes
pred graduationRequirementReached {}