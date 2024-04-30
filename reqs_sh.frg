#lang forge

sig Course {
    prereqs: set Course
}

one sig Transcript {
    first: one Semester,
    next: pfunc Semester -> Semester
}

sig Semester {
    courses_taken: set Course,
    grad_req: set Course
}

pred wellformed_prereqs {
    no c: Course | c in c.^field
    some c: Course | no c.specificPrereqs
}

pred init {
    no Transcript.first.courses_taken
}

pred delta[s1, s2: Semester] {

}

pred traces {
    init
    -- The original comment said that students should take any course they 
    -- have not already taken if they completed their grad reqs. This is 
    -- technically true, but it's also true for all semesters. Maybe I
    -- misunderstood something  
    all s: Transcript.next.Semester | {
        delta[s, Transcript.next[s]]
    }
}

pred gradReqSatisfied[s: Semester] {
    s.grad_req in s.courses_taken
}

run {} for 4 Semester for {next is linear}