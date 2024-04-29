#lang forge

open "reqs.frg"
//// Do not edit anything above this line ////

------------------------------------------------------------------------
pred noPreReqsMet[course: Course, semester:Semester] {
  all c: Course | {
    not no c.prerequisites
    c not in semester.courses_taken
  }
}

test suite for preReqsMet {
  test expect {
      //If the course has no prereqs, then preReqsMet is vacuously true
      noPrereqs : { (all c : Course, semester:Semester | no c.prerequisites and preReqsMet[semester, c] )} is sat
      //If prerequisites and courses taken are the same then the prereqs must be met
      allPrereqsTaken : { (all c : Course, semester:Semester | (c.prerequisites = semester.courses_taken) and preReqsMet[semester, c] )} is sat
      //If there is at least one course and none of its prereqs have been taken, then the prereqs have not been met
      noPrereqMet : { (#{course:Course | not no course} > 1) and (all c : Course, semester:Semester | noPreReqsMet[c, semester] and preReqsMet[semester, c] )} is unsat
      //All prereqs must be met for preReqsMet to be true
      onePrereqNotMet : { (some disj c1, c2 : Course, semester:Semester |  
                              c2 in c1.prerequisites and 
                              c2 not in semester.courses_taken and 
                              preReqsMet[semester, c1] )} is unsat
    }
}

test suite for canTake {
  test expect {
      //If the course has no prereqs, then preReqsMet is vacuously true
      noPrereqs2 : { (all c : Course, semester:Semester | no c.prerequisites and canTake[semester, c] )} is sat
      //If prerequisites and courses taken are the same then the prereqs must be met
      allPrereqsTaken2 : { (all c : Course, semester:Semester | (c.prerequisites = semester.courses_taken) and canTake[semester, c] )} is sat
      //If there is at least one course and none of its prereqs have been taken, then the prereqs have not been met
      noPrereqMet2 : { (#{course:Course | not no course} > 1) and (all c : Course, semester:Semester | noPreReqsMet[c, semester] and canTake[semester, c] )} is unsat
      //All prereqs must be met for preReqsMet to be true
      onePrereqNotMet2 : { (some disj c1, c2 : Course, semester:Semester |  
                              c2 in c1.prerequisites and 
                              c2 not in semester.courses_taken and 
                              canTake[semester, c1] )} is unsat
      takenCourse :  { (some c : Course, semester:Semester | c in semester.courses_taken and canTake[semester, c] )} is unsat
    }
}