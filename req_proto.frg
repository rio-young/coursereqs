#lang forge

abstract sig Boolean {}
one sig True extends Boolean {}
one sig False extends Boolean {}

/*
 * The intro sequence is unique in that unlike other courses, its requirements
 * are in disjunctive normal form:
 * (111 AND 200) OR (150 AND 200) OR (170 AND 200) OR (190)
 * Therefore, we need to special case checking for whether the intro
 * sequence is completed
 */
sig IntroSequence {
    courses: set Course
}

/*
 * For every other course, the requirements are in conjuntive normal form:
 * (330 OR 300) AND (LINALG)
 */
sig EquivalentCourse {
    eq_courses: set Course
}
sig Course {
    requires_intro: one Boolean,
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
    courses_taken: set Course,
    next: lone Semester
}

// Wellformed-ness checks
pred wellformed_introseqs {
    all sequence: IntroSequence | {
        // No intro course should require that the student have taken
        // the intro course
        all course: sequence.courses | course.requires_intro = False
        // At least one course in the sequence should not have any prereqs
        some course: sequence.courses | no course.prerequisites
    }

    -- This is more of an optimization issue, but we don't want duplicates
    no disj s1, s2: IntroSequence | {
        s1.courses = s2.courses
    }
}

pred wellformed_equivalent_courses {
    -- This is more of an optimization issue, but we don't want duplicates
    no disj e1, e2: EquivalentCourse | {
        e1.eq_courses = e2.eq_courses 
    }
}

pred wellformed_prerequisites {
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
    wellformed_introseqs
    wellformed_equivalent_courses
    wellformed_gradreqs
    wellformed_prerequisites
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
}

pred introseq_satisfied[semester: Semester] {
    some seq: IntroSequence | {
        // seq.courses in semester.courses_taken
        (seq.courses & semester.courses_taken) = seq.courses
    }
}

/* Rio
 * if the course has no prerequisites or all prerequisites have been taken
 */
pred prerequisites_met[semester: Semester, course: Course] {
    all courseSet: course.prerequisites | {
        some (courseSet.eq_courses & semester.courses_taken)
    }
}

/* Rio
 * Checks if a student can take a course after the given semester
 * A student can take a course if:
 *   They have taken the intro if that's needed
 *   They have taken all prerequisites for the course
 */
pred can_take[semester: Semester, course: Course] {
    prerequisites_met[semester, course]
    course.requires_intro = True => introseq_satisfied[semester]
}

pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes
    s1.courses_taken != s2.courses_taken
    -- All the courses taken in s1 are stored in s2
    s1.courses_taken in s2.courses_taken

    all new_course: s2.courses_taken - s1.courses_taken | {
        can_take[s1, new_course]
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
    GraduationReqs.requirements in s.courses_taken
}

run {traces} for exactly 8 Semester, 20 Course for {next is linear}