/*
 * 2020.11.25  - Created | Translate complete
 */
import 'person.dart';
import 'section.dart';

class Professor extends Person {
  //------------
  // Attributes.
  //------------
  String title;
  String department;

  List<Section> teaches = [];

	//----------------
	// Constructor(s).
	//----------------
  Professor(String name, String ssn, this.title, this.department)
      : super(name, ssn);

	//-----------------------------
	// Miscellaneous other methods.
	//-----------------------------
  @override
  void display() {
    // First, let's display the generic Person info.
    super.display();
    // Then, display Professor-specific info.
    print('Professor-Specific Information:');
    print('\tTitle: $title');
    print('Teaches for Dept.:  $department');
    displayTeachingAssignments();
    // Finish with a blank line.
    print('');
  }

  @override
  String toString() {
    return '$name ($title, $department)';
  }

  void displayTeachingAssignments() {
    print('Teaching Assignments for $name:');

    // We'll step through the teaches ArrayList, processing Section objects one at a time.

    if (teaches.isEmpty) {
      print("\t(none)");
    } else {
      teaches.forEach((section) {
        // Note how we call upon the Section object to do a lot of the work for us!
        print('\tCourse No.:  ${section.representedCourse.courseNo}');
        print('\tSection No.:  ${section.sectionNo}');
        print('\tCourse Name:  ${section.representedCourse.courseName}');
        print('\tDay and Time:  ${section.dayOfWeek} - ${section.timeOfDay}');
        print("\t-----");
      });
    }
  }

  void agreeToTeach(Section section) {
    teaches.add(section);
    // We need to link this bidirectionally.
    section.instructor = this;
  }
}
