#lang forge

abstract sig Season {}
one sig Fall, Spring extends Season {}

abstract sig Boolean {}
one sig True, False extends Boolean {}

/*
 * Course requirements are in conjuntive normal form:
 * (330 OR 300) AND (LINALG)
 */
sig EquivalentCourse {
    eq_courses: set Course
}
sig Course {
    prerequisites: set EquivalentCourse,
    available_semesters: set Season
}

sig Professor {
  courses: set Course,
  on_sabbatical: one Boolean
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
    next: lone Semester,
    season: one Season
}

pred wellformed_equivalent_courses {
    -- This is more of an optimization issue, but we don't want duplicates
    no disj e1, e2: EquivalentCourse | {
        e1.eq_courses = e2.eq_courses 
    }
}

pred wellformed_prereqs {
    all c: Course | {
      no c.prerequisites or
      (some c2: c.prerequisites.eq_courses | {
        not reachable[c, c2, prerequisites, eq_courses]
      })
    }
    some c: Course | no c.prerequisites
}

-- CS1570+CS1010 fails this
pred wellformed_prereqs_with_no_cycles {
    no c: Course | reachable[c, c, prerequisites, eq_courses]
    some c: Course | no c.prerequisites
}

pred wellformed_courses {
    all c: Course | some c.available_semesters
    wellformed_prereqs
}

pred wellformed_gradreqs {
    some GraduationReqs.requirements
}

pred wellformed_transcript {
    Transcript.first = Semester - Semester.next
}

pred wellformed_professors{
  all course: Course | some p: Professor | course in p.courses
}

pred wellformed {
    wellformed_professors
    wellformed_equivalent_courses
    wellformed_gradreqs
    wellformed_courses
    wellformed_transcript
}

pred init {
    no Transcript.first.courses_taken
    Transcript.first.season = Fall

    all c: Transcript.first.taking | {
        can_take[Transcript.first, c]
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
    semester.season in course.available_semesters
    some p: Professor | {
      course in p.courses and p.on_sabbatical = False
    }
    course not in semester.courses_taken
}

pred delta[s1, s2: Semester] {
    -- GUARD
    
    -- ACTION
    -- Courses taken changes?
    -- NOT NECESSARILY, could take no CS courses in a semester (e.g. study abroad)
    // s1.courses_taken != s2.courses_taken

    s1.courses_taken in s2.courses_taken
    s1.taking = s2.courses_taken - s1.courses_taken
    all new_course: s2.taking | {
        can_take[s2, new_course]
    }

    s1.season != s2.season
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
    some s: Semester | no s.next implies {
        gradreq_satisfied[s]
    }

    -- No more than 5 courses can be taken in a single semester
    all s: Semester | #{s.taking} <= 5
}

pred gradreq_satisfied[s: Semester] {
    GraduationReqs.requirements in (s.courses_taken + s.taking)
}