#lang forge

// open "reqs.frg"
open "req_proto.frg"
//// Do not edit anything above this line ////

------------------------------------------------------------------------

pred someIntroCourse {
  not (
    some Course and (all c : Course | some c.prerequisites)
  )
}

pred noCourseCycle {
  no c1, c2 : Course | {
    reachable[c1,c2,prerequisites]
    reachable[c2,c1,prerequisites]
  }
}

test suite for wellformed_prereqs {
  assert wellformed_prereqs is sufficient for someIntroCourse
  assert wellformed_prereqs is sufficient for noCourseCycle

  test expect {
    oneCourse: {
      #{Course} = 1
      wellformed_prereqs
    } is sat

    wellformed_prereqs_not_vacuous: { wellformed_prereqs } is sat
    //If there are no courses, this is vacuously true
    noCourses : { (#{course:Course | not no course} = 0) } is sat
  }

  example valid is wellformed_prereqs for {
      Transcript = `Transcript
      EquivalentCourse = `e
      Course = `c1 + `c2
      `e.eq_courses = `c1
      prerequisites = `c2 -> `e
  }

  example invalid is not wellformed_prereqs for {
      -- FILL ME IN
      Transcript = `Transcript
      Course = `c1 + `c2 + `c3
      EquivalentCourse = `e1 + `e2 + `e3
      `e1.eq_courses = `c1
      `e2.eq_courses = `c2
      `e3.eq_courses = `c3

      prerequisites = `c2 -> `e1 + `c1 -> `e3 + `c3 -> `e2
  }
}

pred noprerequisites_met[course: Course, semester:Semester] {
  all c: Course | {
    not no c.prerequisites
    c not in semester.courses_taken
  }
}

pred noPrereqs[c: Course] {
  no c.prerequisites
}

//At least one course in the equivalence class is in semester.courses_taken
pred oneEquivSatisfied[eq: EquivalentCourse, semester: Semester] {
  some (eq.eq_courses & semester.courses_taken)
}

test suite for prerequisites_met {
  // No courses have prereqs, prereqs would be met
  assert all c: Course, s: Semester | noPrereqs[c] is sufficient for prerequisites_met[s, c]

  test expect {

      //If the course has no prerequisites, then prerequisites_met is vacuously true
      noprerequisites : { (all c : Course, semester:Semester | no c.prerequisites and prerequisites_met[semester, c] )} is sat
      //If prerequisites and courses taken are the same then the prerequisites must be met
      allprerequisitesTaken : { (all c : Course, semester:Semester | (c.prerequisites.eq_courses = semester.courses_taken) and prerequisites_met[semester, c] )} is sat
      //If there is at least one course and none of its prerequisites have been taken, then the prerequisites have not been met
      noPrereqMet : { (#{course:Course | not no course} > 1) and (all c : Course, semester:Semester | noprerequisites_met[c, semester] and prerequisites_met[semester, c] )} is unsat
      //All prerequisites must be met for prerequisites_met to be true
      onePrereqNotMet : { (some c1: Course, c2 : EquivalentCourse, semester:Semester |  
                              c2 in c1.prerequisites and 
                              not oneEquivSatisfied[c2, semester] and 
                              prerequisites_met[semester, c1] )} is unsat
    }
}

test suite for canTake {
  test expect {
      //If the course has no prerequisites, then preReqsMet is vacuously true
      noprerequisites2 : { (all c : Course, semester:Semester | no c.prerequisites and canTake[semester, c] )} is sat
      //If prerequisites and courses taken are the same then the prerequisites must be met
      allprerequisitesTaken2 : { (all c : Course, semester:Semester | (c.prerequisites = semester.courses_taken) and canTake[semester, c] )} is sat
      //If there is at least one course and none of its prerequisites have been taken, then the prerequisites have not been met
      noPrereqMet2 : { (#{course:Course | not no course} > 1) and (all c : Course, semester:Semester | nopreReqsMet[c, semester] and canTake[semester, c] )} is unsat
      //All prerequisites must be met for preReqsMet to be true
      onePrereqNotMet2 : { (some disj c1, c2 : Course, semester:Semester |  
                              c2 in c1.prerequisites and 
                              c2 not in semester.courses_taken and 
                              canTake[semester, c1] )} is unsat
      takenCourse :  { (some c : Course, semester:Semester | c in semester.courses_taken and canTake[semester, c] )} is unsat
    }
}

// test suite for can_take {
//   test expect {
//       //If the course has no prerequisites, then prerequisites_met is vacuously true
//       noprerequisites2 : { (all c : Course, semester:Semester | no c.prerequisites and can_take[semester, c] )} is sat
//       //If prerequisites and courses taken are the same then the prerequisites must be met
//       allprerequisitesTaken2 : { (all c : Course, semester:Semester | (c.prerequisites = semester.courses_taken) and can_take[semester, c] )} is sat
//       //If there is at least one course and none of its prerequisites have been taken, then the prerequisites have not been met
//       noPrereqMet2 : { (#{course:Course | not no course} > 1) and (all c : Course, semester:Semester | noprerequisites_met[c, semester] and can_take[semester, c] )} is unsat
//       //All prerequisites must be met for prerequisites_met to be true
//       onePrereqNotMet2 : { (some disj c1, c2 : Course, semester:Semester |  
//                               c2 in c1.prerequisites and 
//                               c2 not in semester.courses_taken and 
//                               can_take[semester, c1] )} is unsat
//       takenCourse :  { (some c : Course, semester:Semester | c in semester.courses_taken and can_take[semester, c] )} is unsat
//     }
// }

/* TESTS ADDED ON 5/8 */
test suite for traces {
  test expect {
    -- There never exists a trace such that someone takes more than 5 courses in a semester.
    noSemestersOver5Courses: {
      traces implies {
        no s: Semester | #{s.taking} > 5
      }
    } is theorem

    -- There exists a trace such that the graduation requirements are met.
    graduationRequirementsCanBeMet: {
      traces
      some s: Semester | gradreq_satisfied[s]
    } is sat

    -- There never exists a trace where the same course is being taken in different semesters.
    tookSameCourseInDifferentSemesters: {
      traces
      some c: Course | {
        some disj s1, s2: Semester | {
          c in s1.taking
          c in s2.taking
        }
      }
    } is unsat
  }
}
