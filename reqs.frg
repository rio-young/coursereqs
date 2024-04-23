#lang forge/temporal

option max_tracelength 8
option min_tracelength 8

sig Course {
  // professor: one Professor,
  intro_completed: bool
  prerequisites: set EquivalenceClass
}

// AND relation between courses
// e.g. CS17 and CS200
sig IntroSequence {
  courses: set Course
}

sig Pathway {
  core: set Course
  related: set Course
}

pred pathway_completed[pathway: Pathway] {
  // #{courses_taken & pathway.core} >= 2 or
  // some courses_taken & pathway.core && some courses_taken & pathway.related
  //student has taken at least one core course
  //and at least one course in core or related besides 
}

// OR relation between courses
// e.g. CS300 or CS33, CS19 or (CS17 and CS200), CS22 or CS1010
sig EquivalenceClass {
  equiv: set Course
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
fun getHighestPrereq[student: Student, course: Course]: lone Course {
  -- If the course has no prereqs, return the course itself
  some course.prerequisites => {
    -- All the courses reachable from all the Course->Prereq relations in the model
    Course.^((Course->Course & Course->prerequisites) & (Course->Course))
  } else { course }
}


//Rio 
//Helper method
pred equivalenceClassReached[equivalenceClass: EquivalenceClass, semester: Semester] {
  // all classes in equivalence class are in semester.courses_taken
  all course: Course | {
    course in equivalenceClass.courses =>  course in semester.courses_taken
  }
}

//Rio
//if the course has no prereqs or
//all prereqs have already been taken (perhaps we can do this recursively?)
pred preReqsMet[semester: Semester, course: Course] {
  // ASSUMING semester.courses_taken gives ALL classes previously taken not just those taken in that semester
  //there exists one equivalence class such that all of its classes are satisfied
  // some eq: EquivalenceClass | {
  //   eq in course.prerequisites and equivalenceClassReached[eq, semester]
  // }
  all c: Course | {
    c in course.prerequisites =>  course in semester.courses_taken
  }
}

//Rio
//Checks if a student can take a course after the given semester
// A student can take a course if:
  // They have not already taken the course
  // They have taken all prereqs for the course
  //will probably use preReqsMet
pred canTake[semester: Semester, course: Course] {
  // either course.prerequisites is empty or preReqsMet[semester, course]
  no course.prerequisites or preReqsMet[semester, course]
}

//Michael
// Take an appropriate transition from one semester to the next
pred semesterTransition[ s1, s2: Semester] {
  -- GUARD
  
  -- ACTION
  -- Courses taken changes
  s1.courses_taken != s2.courses_taken
  -- All the courses taken in s1 are stored in s2
  s1 in s2

  -- FRAME
  -- Graduation requirements stay the same
  s1.grad_req = s2.grad_req
}

//Seong-Heon
// if the courses taken by a student matches all those in grad requirements they can:
  // take any courses that they have not already taken and that they can take
pred traces {}

//Seong-Heon
//checks if a student has taken all required courses
pred graduationRequirementReached {}
