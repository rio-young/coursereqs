/**
 * Sterling visualizer.
 */

// Compute the number of semesters
const numSems = instance.signature("Semester").tuples().length;

const stage = new Stage();

/**
 * Initialize the semester grid
 * e.g. [ Sem1 | Sem2 | Sem3 | ... | Sem8 ]
 */
const semesterGrid = new Grid({
  grid_location: { x: 20, y: 20 },
  cell_size: { x_size: 200, y_size: 100 },
  grid_dimensions: { x_size: numSems, y_size: 1 },
});

// Add the name of each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (Semester.atom("Semester" + s) != null) {
    const semesterTbox = new TextBox({
      text: Semester.atom("Semester" + s).id(),
      coords: { x: 0, y: 0 },
      color: "black",
      fontsize: 16,
    });
    semesterGrid.add({ x: s, y: 0 }, semesterTbox);
  }
}

function listCourses(semesterAtom) {
  let ret = "";
  const courses = semesterAtom
    .join(courses_taken)
    .tuples()
    .map((tuple) => {
      return tuple.atoms();
    });
  for (const courseAtom of courses) {
    ret += courseAtom.toString() + ", ";
  }
  return ret;
}

/**
 * Initialize the courses grid. Positioned directly underneath the semesterGrid.
 * e.g. [ Courses for Semester 1 | Courses for Semester 2 | ... | Courses for Semester 8 ]
 */
const coursesGrid = new Grid({
  grid_location: { x: 20, y: 40 },
  cell_size: { x_size: 200, y_size: 400 },
  grid_dimensions: { x_size: numSems, y_size: 1 },
});

// Add the courses for each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (Semester.atom("Semester" + s) != null) {
    const coursesTbox = new TextBox({
      text: listCourses(Semester.atom("Semester" + s)),
      coords: { x: 0, y: 0 },
      color: "black",
      fontsize: 12,
    });
    coursesGrid.add({ x: s, y: 0 }, coursesTbox);
  }
}

// Add the table to `stage` and render it
stage.add(semesterGrid);
stage.add(coursesGrid);
stage.render(svg, document);
