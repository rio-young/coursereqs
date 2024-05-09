# coursereqs

# # Modeling courses and course requirements at Brown

In this project, we are attempting to model courses at Brown and their prerequisites, the different graduation requirements and the relationship between the two. We do this by constraining the problem in a number of different ways. For example, we implemented a variety of different predicates to ensure wellformedness such as wellformed_introseqs which ensures that intro level courses do not have any prerequisite courses and wellformed_equivalent_courses which ensures that there are no circular dependencies when it comes to prerequisite courses.

We represent course prereqs with sets of equivalent courses which themselves contain sets of courses. The reasoning for this would best be explained with an example of a real course and its requirements. The course CSCI 1515: Applied Cryptography lists these as its prerequisites: (CSCI 0200 or 0220) and (CSCI 0300, 0330, 1310, 1950S or 1330). There are different "buckets" from which a student can have taken a class from but they must have taken at least one course from each "bucket". We represent this by having an AND relation between a course's equivalent courses (or the buckets) and an OR relationship within the equivalent course's courses (or the classes within each bucket).

As we move from semester to semester, we make sure that the courses we have taken remain on our transcript and that any new classes added to the transcript are ones that we have met the requirements for by having taking the prerequisite courses.

# # Stakeholders:

This model is primarily intended for students, though some other stakeholders could include Brown administration and faculty. Students could potentially use it to check whether they would be able to take certain courses and still meet graduation requirements, check if they can graduate within a certain timeframe, or see different way in which they can meet graduation requirements. Brown administration could use the model when changing graduation requirements to monitor if the change is still completable by students and how much leeway a new change might afford students in terms of choice of courses. Brown faculty could use the model if they want to change one of their courses' prerequisites (whether removing or adding) to see if there are any circular requirements.

# # Process

Due to the "bucket" nature of prerequisite courses, we were initially unsure of the best way to implement this. We first thought that the number of cases were there would be multiple kinds of prereqs would be few and far between, so we implemented prerequisistes to simply be a set of courses. However, after creating optimizer instances, we found that many courses had multiple prereq options, so we pivoted to our EquivalentCourse design.
