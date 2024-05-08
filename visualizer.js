/**
 * Sterling visualizer.
 */

// Compute the number of semesters
const numSems = instance.signature("Semester").tuples().length;

const stage = new Stage();

/**
 * Initialize course schedule grid.
 */

const scheduleGrid = new Grid({
  grid_location: { x: 20, y: 20 },
  cell_size: { x_size: 200, y_size: 50 },
  grid_dimensions: { x_size: numSems - 1, y_size: 6 },
});

// Add the name of each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (Semester.atom("Semester" + (s + 1)) != null) {
    const semesterTbox = new TextBox({
      text: Semester.atom("Semester" + (s + 1)).id(),
      coords: { x: 0, y: 0 },
      color: "black",
      fontsize: 16,
    });
    scheduleGrid.add({ x: s, y: 0 }, semesterTbox);
  }
}

// Add the courses for each semester into the grid
for (let s = 0; s < numSems; s++) {
  if (Semester.atom("Semester" + (s + 1)) != null) {
    const courseList = listCourses(Semester.atom("Semester" + (s + 1)));
    if (courseList.length > 5) {
      const errorTbox = new TextBox({
        text: `Taking ${courseList.length} courses`,
        coords: { x: 0, y: 0 },
        color: "red",
        fontsize: 12,
      });
      scheduleGrid.add({ x: s, y: 1 }, errorTbox);
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
stage.render(svg, document);
