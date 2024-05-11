# Using coursereqs
Coursereqs is aims to help you find the flaws/issues in a real set of courses. While the set of courses we (the team) used is Brown CS, we wanted to make it possible for a broader audience to use coursereqs. Therefore, we provide some tooling to improve the usability of coursereqs, which will be described here.

## Instance Generator DSL (Domain Specific Language)
To apply coursereqs on a real set of courses, you must make an optimizer instance of those courses. Forge as of 3.4 does not offer a very ergonomic way of making optimizer instances, and typing out tens of hundreds of backtick-prefixed instances will make your pinky ache (speaking from experience). To make the process of writing instances easier, we offer a YAML-based DSL with a friendlier syntax. Note that while we do support semester times (fall, spring, both), we do not support course instructors.

### Grammar
The semi-formal grammar for the DSL is

```
_file_               := _semester_ \n ...
_semester_           := _semester_timing_:
                            _course_id_: [_equivalent_courses_+]
                     ...
_semester_timing_    := "fall" | "spring" | "both"
_course_id_          := [0-9][0-9][0-9][0-9]?[a-zA-Z]
_equivalent_courses_ := [_course_id_+]
```

```yaml
# Example
fall:
    100: []
    200: [[100, 110]]
spring:
    300: [[200]]
    330: [[200]]
    220: []
    400K: [[300, 330], [220]] # require one of 300, 330 AND 220
both:
    1900: [[400K]]
```

### Compiler
We also have an accompanying compiler at `optimizer_generator.py` that turns the DSL into a forge optimizer instance.
Run `pip install -r requirements.txt` to install dependencies (just pyyaml) and run `python optimizer_generator.py <name_of_input_file>` to generate a forge-compatible instance.

Its behavior is mostly straighforward, but it does apply some mild transformations. Specifically, if a course appears in the DSL as a potential prerequisite for some courses, but is not offered, it will remove that course from all prerequisites. For instance, the compiler will not generate a `CS0110` atom for the above example. Because the user did not provide any information about the course besides that it may be used as a prerequisite for other courses, we are unable to generate a proper course atom. Thus, we instead remove the course from the instance entirely.

This occurred quite frequently in our instance. Courses like `CS0160` and `CS0180` were no longer offered and instead replaced by `CS0200`. But, because there still may be students who took `CS0160/0180` before their "retirement", courses often list `[160, 180, 200]` as a prerequisite.

We could instead generate an atom for such non-existent courses with default values, but reasonable default values led to unreasonable results. For example, if we set the prerequisites of non-existent courses to nothing, we may have cases where upper level courses which are no longer offered are always enrollable. This defeats the purpose of accurately modeling prerequisite relations.