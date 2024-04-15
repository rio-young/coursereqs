#lang forge/temporal

option max_tracelength 8
option min_tracelength 8

sig Class {
  professor: one Professor,
  prerequisites: set Class
}

sig Professor {
  classes: set Class
}

sig Student {
  classes_taken: set Class,
  grad_req: set Class
}

//maximum number of classes a student can take in each state (where a state represents a semester)
fun MAX_CLASSES: one Int { 5 }

//minimum number of classes a student can take in each state (where a state represents a semester)
fun MIN_CLASSES: one Int { 3 }

// there should be no loops in class prereqs
// There should be classes with no prereqs
pred wellformed_rereqs {}

//all students should start having taken no classes
pred init {}

//if the course has no prereqs return null
//if the course has prereqs, return the furthest back class that has no prereqs
//can add some optimization
  //ex: if there are multiple courses with the same prereq, prioritize that one
fun getHighestPrereq[student: Student, class: Class]: lone Class {}

//if the course has no prereqs or
//all prereqs have already been taken (perhaps we can do this recursively?)
pred preReqsMet[student: Student, class: Class] {}

// A student can take a class if:
  // They have not already taken the class
  // They have taken all prereqs for the class
pred canTake[student: Student, class: Class] {}

// if the classes taken by a student matches all those in grad requirements they can:
  // take any classes that they have not already taken and that they can take
pred traces {}

//checks if a student has taken all required classes
pred graduationRequirementReached {}