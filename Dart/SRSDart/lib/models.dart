// Models library
// --------------
// Classes: Course | EnrollmentStatus | Person | Proffessor |  SceduleOfClasses | Section | Student | Transcript | TrasncriptEntry 
//
// 
/*
 * 2020.11.25  - Created 
 * 2020.11.26  - Fixed bug - Models/Section.enroll() use for in, since no way to return from foreach in Dart
 */

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class Course {
  //------------
  // Attributes.
  //------------
  String courseNo;
  String courseName;
  double credits;
  List<Section> offeredAsSection = [];
  List<Course> prerequisites = [];

  //----------------
  // Constructor(s).
  //----------------

  Course(this.courseNo, this.courseName, this.credits);

  //--
  //-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  void display() {
    print('Course Information:');
    print('\tCourse No.:  $courseNo');
    print('\tCourse Name:  $courseName');
    print('\tCredits:  $credits');
    print('\tPrerequisite Courses:');

    prerequisites.forEach((course) {
      print('\t\t${course.toString()}');
    });

    // Note use of print vs. println in next line of code.
    print('\tOffered As Section(s):  ');
    offeredAsSection.forEach((section) {
      print('${section.sectionNo} ');
    });

    // Finish with a blank line.
    print('');
  }

  String toString() {
    return '$courseNo:  $courseName';
  }

  void addPrerequisite(Course c) {
    prerequisites.add(c);
  }

  void addSection(Section s) {
    offeredAsSection.add(s);
  }

  bool hasPrerequisites() => prerequisites.isNotEmpty;

  Section scheduleSection(String day, String time, String room, int capacity) {
    // Create a new Section (note the creative way in which we are assigning a section number) ...
    Section s = new Section(
        offeredAsSection.length + 1, day, time, this, room, capacity);
    // ... and then remember it!
    addSection(s);
    return s;
  }
}

enum EnrollmentStatus {
  SUCCESS,
  SECTION_FULL,
  PREREQ,
  ENROLLED
}

const enrollmentInfoMap = {
  EnrollmentStatus.SUCCESS: 'Enrollment successful!  :o)',
  EnrollmentStatus.SECTION_FULL: 'Enrollment failed;  section was full.  :op',
  EnrollmentStatus.PREREQ:
      'Enrollment failed; prerequisites not satisfied.  :op',
  EnrollmentStatus.ENROLLED: 'Enrollment failed; previously enrolled.  :op'
};

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
// We are making this class abstract because we do not wish for it to be instantiated.
abstract class Person {
  //------------
  // Attributes.
  //------------
  String name;
  String ssn;

  //----------------
  // Constructor(s).
  //----------------
  Person(this.name, this.ssn);

  Person.createNew() {
    name = '?';
    ssn = '???-??-????';
  }

  //-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  //String toString();

  void display() {
    print('Person Information:');
    print('\tName: $name');
    print('Soc. Security No.:  $ssn');
  }
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
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
      print('\t(none)');
    } else {
      teaches.forEach((section) {
        // Note how we call upon the Section object to do a lot of the work for us!
        print('\tCourse No.:  ${section.representedCourse.courseNo}');
        print('\tSection No.:  ${section.sectionNo}');
        print('\tCourse Name:  ${section.representedCourse.courseName}');
        print('\tDay and Time:  ${section.dayOfWeek} - ${section.timeOfDay}');
        print('\t-----');
      });
    }
  }

  void agreeToTeach(Section section) {
    teaches.add(section);
    // We need to link this bidirectionally.
    section.instructor = this;
  }
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class ScheduleOfClasses {
  //------------
  // Attributes.
  //------------
  String semester;
  // This Map stores Section object references, using a String concatenation of course no. and section no. as the
  // key, e.g., "MATH101 - 1".
  Map<String, Section> sectionsOffered = {};

  //----------------
  // Constructor(s).
  //----------------
  ScheduleOfClasses(this.semester);

	//-----------------------------
	// Miscellaneous other methods.
	//-----------------------------
  void display() {
    print('Schedule of Classes for $semester\n');

    // Iterate through all the values in the HashMap.
    sectionsOffered.values.forEach((s) {
      s.display();
      print('');
    });

  }

  void addSection(Section s) {
		// We formulate a key by concatenating the course no.
		// and section no., separated by a hyphen.

		String key = "${s.representedCourse.courseNo} - ${s.sectionNo}";
		sectionsOffered[key] = s;

		// Bidirectionally link the ScheduleOfClasses back to the Section.

		s.offeredIn = this;
	}

	// // The full section number is a concatenation of the
	// // course no. and section no., separated by a hyphen;
	// // e.g., "ART101 - 1".

	// Section findSection(String fullSectionNo) {
	// 	return sectionsOffered[fullSectionNo];
	// }

	bool isEmpty() => sectionsOffered.isEmpty;
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class Section {
  //------------
  // Attributes.
  //------------
  int sectionNo;
  String dayOfWeek, timeOfDay, room;
  int seatingCapacity;

  Course representedCourse;

  ScheduleOfClasses offeredIn;

  Professor instructor;

// The enrolledStudents Map stores Student object references, using each Student's ssn as a String key.
  Map<String, Student> enrolledStudents = {};

  // Stores TranscriptEntry object references, using a reference to the Student to whom it belongs as key.
  Map<Student, TranscriptEntry> assignedGrades = {};

  //----------------
  // Constructor(s).
  //----------------
  Section(this.sectionNo, this.dayOfWeek, this.timeOfDay,
      this.representedCourse, this.room, this.seatingCapacity);

  //-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  // For a Section, we want its String representation to look
  // as follows:
  //
  //	MATH101 - 1 - M - 8:00 AM

  String toString() {
    return '${representedCourse.courseNo} - $sectionNo - $dayOfWeek - $timeOfDay';
  }

  // The full section number is a concatenation of the
  // course no. and section no., separated by a hyphen;
  // e.g., 'ART101 - 1'.

  String getFullSectionNo() {
    return '${representedCourse.courseNo} - $sectionNo';
  }

// We use an enum -- EnrollmentStatus -- to return an indication of the
  // outcome of the request to enroll Student s.  See EnrollmentStatus.java
  // for details on this enum.

  EnrollmentStatus enroll(Student s) {
    // First, make sure that this Student is not already
    // enrolled for this Section, and that he/she has
    // NEVER taken and passed the course before.

    Transcript transcript = s.transcript;

    if (s.isCurrentlyEnrolledInSimilar(this) ||
        transcript.verifyCompletion(representedCourse)) {
      return EnrollmentStatus.ENROLLED;
    }

    // If there are any prerequisites for this course, check to ensure that the Student has completed them.

    //Course c = this.getRepresentedCourse();

    if (representedCourse.hasPrerequisites()) {
      for(Course pre in representedCourse.prerequisites){
        // See if the Student's Transcript reflects
        // successful completion of the prerequisite.
        if (!transcript.verifyCompletion(pre)) {
          return EnrollmentStatus.PREREQ;
        }
      }
    }

    // If the total enrollment is already at the the capacity for this Section, we reject this
    // enrollment request.

    if (!_confirmSeatAvailability()) {
      return EnrollmentStatus.SECTION_FULL;
    }

    // If we made it to here in the code, we're ready to officially enroll the Student.

    // Note bidirectionality:  this Section holds onto the Student via the Map, and then
    // the Student is given a handle on this Section.

    enrolledStudents['${s.ssn}'] = s;
    s.addSection(this);

    return EnrollmentStatus.SUCCESS;
  }

  // A private 'housekeeping' method.
  bool _confirmSeatAvailability() =>
      (enrolledStudents.length < seatingCapacity);

  // This method returns the value null if the Student has not
  // been assigned a grade.

  String getGrade(Student s) {
    String grade = null;

    // Retrieve the associated TranscriptEntry object for this specific
    // student from the assignedGrades HashMap, if one exists, and in turn
    // retrieve its assigned grade.

    TranscriptEntry te = assignedGrades[s];
    if (te != null) {
      grade = te.grade;
    }

    // If we found no TranscriptEntry for this Student, a null value
    // will be returned to signal this.

    return grade;
  }

  bool isSectionOf(Course c) => c == representedCourse;

  bool drop(Student s) {
    // We may only drop a student if he/she is enrolled.
    if (!s.isEnrolledIn(this)) {
      return false;
    } else {
      // Find the student in our HashMap, and remove it.
      enrolledStudents.remove(s.ssn);
      // Note bidirectionality.
      s.dropSection(this);
      return true;
    }
  }

  // int getTotalEnrollment() {
  // 	return enrolledStudents.size();
  // }

  void display() {
    print('Section Information:');
    print('\tSemester:  ${offeredIn.semester}');
    print('\tCourse No.:  ${representedCourse.courseNo}');
    print('\tSection No:  $sectionNo');
    print('\tOffered:  $dayOfWeek at $timeOfDay');
    print('\tIn Room:  $room');
    if (instructor != null) {
      print('\tProfessor:  ${instructor.name}');
    }

    displayStudentRoster();
  }

  void displayStudentRoster() {
    final String text = enrolledStudents.length == 0
        ? '.'
        : ', as follows:${enrolledStudents.values.map((s) => s.name).join('\t\t')}';
    print('\tTotal of ${enrolledStudents.length} students enrolled ${text}');
  }

  bool postGrade(Student s, String grade) {
    // First, validate that the grade is properly formed by calling
    // a utility method provided by the TranscriptEntry class.

    if (!TranscriptEntry.validateGrade(grade)) {
      return false;
    }

    // Make sure that we haven't previously assigned a
    // grade to this Student by looking in the Map
    // for an entry using this Student as the key.  If
    // we discover that a grade has already been assigned,
    // we return a value of false to indicate that
    // we are at risk of overwriting an existing grade.
    // (A different method, eraseGrade(), can then be written
    // to allow a Professor to change his/her mind.)

    if (assignedGrades[s] != null) {
      return false;
    }

    // First, we create a new TranscriptEntry object.  Note
    // that we are passing in a reference to THIS Section,
    // because we want the TranscriptEntry object,
    // as an association class ..., to maintain
    // 'handles' on the Section as well as on the Student.
    // (We'll let the TranscriptEntry constructor take care of
    // linking this T.E. to the correct Transcript.)

    TranscriptEntry te = new TranscriptEntry(s, grade, this);

    // Then, we 'remember' this grade because we wish for
    // the connection between a T.E. and a Section to be
    // bidirectional.

    assignedGrades[s] = te;

    return true;
  }
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class Student extends Person {
  //------------
  // Attributes.
  //------------
  String major, degree;
  Transcript transcript;
  List<Section> attends = [];

  Student(String name, String ssn, this.major, this.degree) : super(name, ssn) {
    transcript = Transcript(this);
  }

  Student.fromSSN(String ssn) : this('TBD', ssn, 'TBD', 'TBD');

//-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  void display() {
    // First, let's display the generic Person info.
    super.display();

    // Then, display Student-specific info.

    print('Student-Specific Information:');
    print('\tMajor:  $major');
    print('\tDegree:  $degree');
    displayCourseSchedule();
    transcript.display();

    // Finish with a blank line.
    print('');
  }

  // For a Student, we wish to return a String as follows:
  //
  // 	Joe Blow (123-45-6789) [Master of Science - Math]

  String toString() {
    return '$name ($ssn) [$degree - $major]';
  }

  void displayCourseSchedule() {
    // Display a title first.

    print('Course Schedule for $name');

    // Step through the List of Section objects, processing these one by one.
    attends.where((s) => s.getGrade(this) == null).forEach((section) {
      //equal check OK here
      // Since the attends List contains Sections that the Student took in the past as well as those for which
      // the Student is currently enrolled, we only want to report on those for which a grade has not yet been
      // assigned.
      print('\tCourse No.:  ${section.representedCourse.courseNo}');
      print('\tSection No.:  ${section.sectionNo}');
      print('\tCourse Name:  ${section.representedCourse.courseName}');
      print(
          '\tMeeting Day and Time Held:  ${section.dayOfWeek} - ${section.timeOfDay}');
      print('\tRoom Location:  ${section.room}');
      print('\tProfessor\'s Name:  ${section.instructor.name}');
      print('\t-----');
    });
  }

  void addSection(Section s) {
    attends.add(s);
  }

  void dropSection(Section s) {
    attends.remove(s);
  }

  // Determine whether the Student is already enrolled in THIS EXACT Section.

  bool isEnrolledIn(Section s) => attends.contains(s);

  // Determine whether the Student is already enrolled in ANOTHER Section of this SAME Course.

  bool isCurrentlyEnrolledInSimilar(Section s1) {
    bool foundMatch = false;

    Course c1 = s1.representedCourse;

    for (Section s2 in attends) {
      Course c2 = s2.representedCourse;
      if (c1 == c2) {
        //TODO maybe we need to implement equal operator for Course? Think not!
        // There is indeed a Section in the attends() List representing the same Course.
        // Check to see if the Student is CURRENTLY ENROLLED (i.e., whether or not he has
        // yet received a grade).  If there is no grade, he/she is currently enrolled; if
        // there is a grade, then he/she completed the course some time in the past.
        if (s2.getGrade(this) == null) {
          //OK
          // No grade was assigned!  This means that the Student is currently enrolled in a Section of this
          // same Course.
          foundMatch = true;
          break;
        }
      }
    }

    return foundMatch;
  }
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class Transcript {
  List<TranscriptEntry> transcriptEntries = [];
  Student studentOwner;

  Transcript(this.studentOwner);

  //-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  bool verifyCompletion(Course c) {
    bool outcome = false;

    // Step through all TranscriptEntries, looking for one
    // which reflects a Section of the Course of interest.

    for (TranscriptEntry te in transcriptEntries) {
      Section s = te.section;

      if (s.isSectionOf(c)) {
        // Ensure that the grade was high enough.

        if (TranscriptEntry.passingGrade(te.grade)) {
          outcome = true;

          // We've found one, so we can afford to
          // terminate the loop now.

          break;
        }
      }
    }

    return outcome;
  }

  void addTranscriptEntry(TranscriptEntry te) {
    transcriptEntries.add(te);
  }

  void display() {
    print('Transcript for:  ${studentOwner.toString()}');

    if (transcriptEntries.isEmpty) {
      print('\t(no entries)');
    } else {
      transcriptEntries.forEach((te) {
        Section sec = te.section;
        Course c = sec.representedCourse;
        ScheduleOfClasses soc = sec.offeredIn;

        print('\tSemester:        ${soc.semester}');
        print('\tCourse No.:      ${c.courseNo}');
        print('\tCredits:         ${c.credits}');
        print('\tGrade Received:  ${te.grade}');
        print('\t-----');
      });
    }
  }
}

// ******************************************* //
//              CLASS DEFINITION
// ******************************************* //
class TranscriptEntry {
  //------------
  // Attributes.
  //------------
  String grade;
  Student student;
  Section section;
  Transcript transcript;

  //----------------
  // Constructor(s).
  //----------------

  TranscriptEntry(this.student, this.grade, this.section) {
    // Obtain the Student's transcript ...
    // ... and then link the Transcript and the TranscriptEntry together bidirectionally.

    transcript = student.transcript;
    transcript.addTranscriptEntry(this);
  }

  //-----------------------------
  // Miscellaneous other methods.
  //-----------------------------

  // These next two methods are declared to be static, so that they
  // may be used as utility methods.

  static bool validateGrade(String grade) {
    bool outcome = false;

    if (grade == 'F' || grade == 'I') {
      outcome = true;
    }
    if (grade.startsWith('A') ||
        grade.startsWith('B') ||
        grade.startsWith('C') ||
        grade.startsWith('D')) {
      outcome = (grade.length == 1) ||
          ((grade.length == 2) && (grade.endsWith('+') || grade.endsWith('-')));
    }

    return outcome;
  }

  static bool passingGrade(String grade) {
    bool outcome = false;

    // First, make sure it is a valid grade.

    if (validateGrade(grade)) {
      // Next, make sure that the grade is a D or better.
      if (grade.startsWith('A') ||
          grade.startsWith('B') ||
          grade.startsWith('C') ||
          grade.startsWith('D')) {
        outcome = true;
      }
    }

    return outcome;
  }
}

//export 'src/models/person.dart';

//https://dart.dev/tools/pub/package-layout
//https://stackoverflow.com/questions/18454140/how-to-organize-my-dart-project
//export src/my_private_code.dart
