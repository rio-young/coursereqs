/**
 * Sterling visualizer.
 */

// Compute the number of semesters
const numSems = instance.signature("Semester").tuples().length;
const semesterAtoms = Semester.atoms();

const errorMessages = [];

const stage = new Stage();

/**
 * Initialize course schedule grid.
 */

const scheduleGrid = new Grid({
  grid_location: { x: 20, y: 20 },
  cell_size: { x_size: 200, y_size: 50 },
  grid_dimensions: { x_size: numSems, y_size: 6 },
});

// Add the name of each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (semesterAtoms[s] != null) {
    const semesterTbox = new TextBox({
      text: semesterAtoms[s].id(),
      coords: { x: 0, y: 0 },
      color: "black",
      fontsize: 16,
    });
    scheduleGrid.add({ x: s, y: 0 }, semesterTbox);
  }
}

// Add the courses for each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (semesterAtoms[s] != null) {
    const sem = semesterAtoms[s];
    const courseList = listCourses(sem);
    if (courseList.length > 5) {
      errorMessages.push(
        `Taking ${
          courseList.length
        } courses in ${sem.id()}. Try increasing your Int bitwidth to 6.`
      );
    } else {
      for (let r = 1; r < 6; r++) {
        const courseTbox = new TextBox({
          text: courseList[r - 1],
          coords: { x: 0, y: 0 },
          color: "black",
          fontsize: 12,
        });
        scheduleGrid.add({ x: s, y: r }, courseTbox);
      }
    }
  }
}

function listCourses(semesterAtom) {
  const courses = semesterAtom
    .join(taking)
    .tuples()
    .map((tuple) => {
      return tuple.atoms();
    });
  return courses;
}

stage.add(scheduleGrid);

for (let i = 0; i < errorMessages.length; i++) {
  const error = errorMessages[i];
  const errorTbox = new TextBox({
    text: error,
    coords: { x: 500, y: 400 + i * 50 },
    color: "red",
    fontsize: 12,
  });
  stage.add(errorTbox);
}

stage.render(svg, document);
