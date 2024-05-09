#lang forge

/*
 * For every other course, the requirements are in conjuntive normal form:
 * (330 OR 300) AND (LINALG)
 */
sig EquivalentCourse {
    eq_courses: set Course
}
sig Course {
    prerequisites: set EquivalentCourse
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

pred wellformed_equivalent_courses {
    -- This is more of an optimization issue, but we don't want duplicates
    no disj e1, e2: EquivalentCourse | {
        e1.eq_courses = e2.eq_courses 
    }
}

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
    wellformed_equivalent_courses
    wellformed_gradreqs
    wellformed_prereqs
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
}

/* Rio
 * if the course has no prerequisites or all prerequisites have been taken
 */
pred preReqsMet[semester: Semester, course: Course] {
    all courseSet: course.prerequisites | {
        some (courseSet.eq_courses & semester.courses_taken)
    }
}

/* Rio
 * Checks if a student can take a course after the given semester
 * A student can take a course if:
 *   They have taken the intro if that's needed
 *   They have taken all prerequisites for the course
 *   They haven't taken the course before
 */
pred can_take[semester: Semester, course: Course] {
    prerequisites_met[semester, course]
    // course.requires_intro = True => introseq_satisfied[semester]
}

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

run {
    traces
    GraduationReqs.requirements = Course
} for exactly 8 Semester, 20 Course, 5 Int for {next is linear}