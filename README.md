# coursereqs

Team Members (CS logins): Seong-Heon Jung (sjung35), Michael Tu (mstu), Rio Young (ryoung22)

**DEMO VIDEO**: [https://youtu.be/65ppL7wWcMI](https://youtu.be/65ppL7wWcMI)

## Model Architecture

In this project, we modeled the Brown CS curriculum with a focus on the nuances of course prerequisites and graduation requirements. Our full model - the model fulfilling our target goals - is available at `reqs.frg`. A smaller model that just satisifies our foundation goal is also available at `reqs_light.frg`.

### Equivalent Courses

We represent a course's prerequisites as a set of "equivalent courses" which themselves are sets of courses. The reasoning for this would best be explained with an example of a real course and its requirements. The course CSCI 1515 - Applied Cryptography lists these as its prerequisites:

> (CSCI 0200 or 0220) AND (CSCI 0300, 0330, 1310, 1950S or 1330)

There are different "buckets" from which a student can have taken a class from but they must have taken at least one course from each "bucket". We represent this by having an `AND` relation between a course's equivalent courses (or the buckets) and an `OR` relationship within the equivalent course's courses (or the classes within each bucket).

More formally, we realised that the a prerequisite for a course is equivalent to a boolean formula in conjunctive normal form, where each literal corresponds to whether the student took the course. A clause is analogous to our `EquivalentCourse`.

### Graduation Requiements

### Transcript/Semester

As we are working in relational forge, we need some global state to keep track of the passage of time. This is done in the `Transcript` and `Semester` sigs. The `Transcript` simply indicates which semester is the first so that we can assert some preconditions for our model. For example, no courses should have been taken already by the first semester.

`Semester` sigs contain the bulk of the state information including the progression of time with the `next` field. It also keeps track of what courses have been taken already (i.e. before this semester) through `courses_taken` and what course the student is _currently_ taking in said semester through `taking`.For our target model, we also include an `available_semesters` field that keeps track of if a course is available in the Spring or Fall. The validity of our semester to semester transitions are enforced by a `delta` predicate.

## Stakeholders:

This model is primarily intended for students, though some other stakeholders could include Brown administration and faculty.

#### Current + prospective CS concentrators:

Students can use this model to generate a valid course plan that fulfills the CS concentration requirements. Additionally, students can write additional predicates to refine the search space for instances that fit their personal constraints (e.g. want to take CSCI 1710 before senior year).

#### Brown administration and CS faculty:

Brown administration and faculty may be invested in this model to determine the pros and cons of the new CS requirements, compared to the old requirements. They may also be concerned about how limiting the requirements are on students and can gain a rough understanding of this by using our model. Brown administration could use the model when changing graduation requirements to monitor if the change is still completable by students and how much leeway a new change might afford students in terms of choice of courses. Brown faculty could use the model if they want to change one of their courses' prerequisites (whether removing or adding) to see if there are any circular requirements.

#### CS departments at other universities:

Similarly, CS departments at other universities may want to see the possibilities of Brown's CS requirements compared to their own. This model is flexible to handle different sets of graduation requirements, and the sigs are generalized to handle most course management systems.

## Challenges

Due to the "bucketed" nature of prerequisite courses, we were initially unsure of the best way to implement this. We first thought that the number of courses which had multiple kinds of prereqs would be few and far between, so we implemented prerequisistes to naively be a set of courses. However, after reading through C@B to write optimizer instances, we found that many courses had multiple prereq options. We ultimately pivoted to the `EquivalentCourse` design, but we list some alternative ideas we had below:

- Hard coding specific categories into the `Course` sig (e.g. intro sequence, systems, software engineering)
- Using a `Skill` sig instead of `Course`, where each `Skill` can be learned through taking one among many courses which teach that skill

## Visualization

We created a custom visualization that displays the instance in the form of an 8-semester course plan. At the top of the course plan, you can see the semester IDs corresponding to the sequence of semesters generated by Forge. In each column, you will find the courses that a student should take in that semester under the course plan specified by this instance. This visualization assumes that the number of CS courses a student can take in a given semester is between 0 and 5, inclusive. If the number of courses exceeds 5, an error messsage will appear.

If you're using the default visualization, we would recommend you look at the table view, instead of the monstrosity of the graph view 😵‍💫. The `taking` field will show you what courses are planned for each semester. You can also visually verify that all courses planned for a given semester was not previously taken and that their prereqs have all been fulfilled. By the last semester, the `courses_taken` set should match the instance's graduation requirements.

## Using the model

Since our intended audience for the tool was students, we offer some tooling to make using the model easy, including a yaml-based DSL for generating optimizer instances. Read more at [usage.md](usage.md), but the TLDR is to run `runner.frg`
