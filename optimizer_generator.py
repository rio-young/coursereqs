import yaml


class MyLoader(yaml.SafeLoader):
    """Applies custom logic for parsing input YAML file"""

    def construct_yaml_int(self, node):
        """
        Interpret course codes as strings of the desired format.
        Example: 111 -> "`CS0111"
        """

        # Override the default behavior of loading integers as ints.
        # Instead, load them as strings
        stringified = super().construct_scalar(node)

        # Pad them from the left with 0s
        return "`CS" + stringified.zfill(4)

    def construct_scalar(self, node):
        """Prepend course codes with "`CS" """
        return "`CS" + super().construct_scalar(node)


# Register the constructor for loading ints as strings
MyLoader.add_constructor("tag:yaml.org,2002:int", MyLoader.construct_yaml_int)

"""
A set of prereqs. These are OR'd together. In other words, you only need
to take one of courses listed to satisfy this requirement.
"""
EquivalentCourses = list[str]
"""Same as above, except without courses that are not offered"""
OfferedEquivalentCourses = frozenset[str]


def filter_prereq_sets(
    prereq_sets: list[EquivalentCourses], offered_courses: set[str]
) -> list[OfferedEquivalentCourses]:
    """
    Remove courses listed as prereqs that are not currently offered.

    This is necessary because many prereqs listed are not offered, so we don't
    know what the prereqs for such courses are. But, if we simply list them as
    'no prereqs', then it breaks the chain.

    Consider the following. Say CS 1710 has the prereq 180 or 200,
    but 1700 is not offered anymore. When it was offered, the prereq was CS15.
    If we naively say 1700 has no prereqs, the student can bypass the
    (11 or 15 or 17) requirement, which would not be representative of reality.

    Note that we return a frozenset instead of a set because a set is not hashable.
    We eventually need to make a set of sets, and that's not possible with vanilla
    sets as the inner elements.
    """
    filtered = []
    for prereq_set in prereq_sets:
        filtered.append(
            frozenset({prereq for prereq in prereq_set if prereq in offered_courses})
        )
    return filtered


def filter_course_prereq_dict(
    course_to_prereqs: dict[str, list[EquivalentCourses]]
) -> dict[str, list[OfferedEquivalentCourses]]:
    """Wrapper around filter_prereq_sets. Applies the operation to the whole dict"""
    offered_courses = set(course_to_prereqs.keys())

    return {
        course: filter_prereq_sets(prereq_sets, offered_courses)
        for course, prereq_sets in course_to_prereqs.items()
    }


def make_equivalent_courses_index(
    prereq_sets_list: list[OfferedEquivalentCourses],
) -> dict[OfferedEquivalentCourses, int]:
    """
    Merges the equivalent courses with the same components and attaches an id.
    """
    equivalent_course_index = {}
    count = 0
    for prereq_sets in prereq_sets_list:
        for prereq_set in prereq_sets:
            if prereq_set and prereq_set not in equivalent_course_index:
                equivalent_course_index[prereq_set] = count
                count += 1

    return equivalent_course_index

def merge_courses(partitioned_courses):
    all_courses = {}
    for courses in partitioned_courses.values():
        all_courses |= courses
    return all_courses

with open("courses.yaml", "r") as file:
    filecontents = yaml.load(file, MyLoader)

filtered_dict = filter_course_prereq_dict(merge_courses(filecontents))
course_codes = filtered_dict.keys()
content = [
    "--This file was generated automatically",
    f"--Number of Courses: {len(course_codes)}",
    "Season = `Fall + `Spring"
    "Course = " + ", ".join(course_codes),
]

equivalent_courses_index = make_equivalent_courses_index(filtered_dict.values())
for equivalent_courses, id in equivalent_courses_index.items():
    content.append(f"`EquivalentCourse{id} = " + ", ".join(equivalent_courses))

for course, prereq_sets in filtered_dict.items():
    equivalent_course_ids = [
        f"`EquivalentCourse{equivalent_courses_index[prereq_set]}"
        for prereq_set in prereq_sets
        if prereq_set
    ]
    if equivalent_course_ids:
        content.append(
            f"{course}.prerequisites = " + " + ".join(equivalent_course_ids)
        )

for season, courses in filecontents.items():
    if "both" in season:
        for course_id in courses:
            content.append(f"{course_id}.available_semesters = `Fall + `Spring")
    elif "fall" in season:
        for course_id in courses:
            content.append(f"{course_id}.available_semesters = `Fall")
    elif "spring":
        for course_id in courses:
            content.append(f"{course_id}.available_semesters = `Spring")
    else:
        raise f"Unknown season {season}"



with open("output.frg", "w") as file:
    file.writelines(map(lambda line: line + "\n", content))
