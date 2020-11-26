import 'package:barber/models.dart';

List<Professor> faculty;
List<Student> studentBody;
List<Course> courseCatalog;

ScheduleOfClasses scheduleOfClasses = new ScheduleOfClasses('SP2005');

void main(List<String> arguments) {

  Professor p1, p2, p3;

  Student s1, s2, s3;
  Course c1, c2, c3, c4, c5;
  Section sec1, sec2, sec3, sec4, sec5, sec6, sec7;

  // Create various objects by calling the appropriate constructors.  (We'd normally be reading in such data from a database or file ...)

  // -----------
  // Professors.
  // -----------

  p1 = new Professor('Jacquie Barker', '123-45-6789', 'Adjunct Professor',
      'Information Technology');
  p2 =
      new Professor('John Smith', '567-81-2345', 'Full Professor', 'Chemistry');
  p3 = new Professor('Snidely Whiplash', '987-65-4321', 'Full Professor',
      'Physical Education');

  // Add these to the appropriate List.

  faculty = [];
  faculty.add(p1);
  faculty.add(p2);
  faculty.add(p3);

  // ---------
  // Students.
  // ---------

  s1 = new Student('Joe Blow', '111-11-1111', 'Math', 'M.S.');
  s2 = new Student(
      'Fred Schnurd', '222-22-2222', 'Information Technology', 'Ph. D.');
  s3 = new Student('Mary Smith', '333-33-3333', 'Physics', 'B.S.');

  // Add these to the appropriate List.

  studentBody = [];
  studentBody.add(s1);
  studentBody.add(s2);
  studentBody.add(s3);

  // --------
  // Courses.
  // --------

  c1 = new Course('CMP101', 'Beginning Computer Technology', 3.0);
  c2 = new Course('OBJ101', 'Object Methods for Software Development', 3.0);
  c3 = new Course('CMP283', 'Higher Level Languages (Java)', 3.0);
  c4 = new Course('CMP999', 'Living Brain Computers', 3.0);
  c5 = new Course('ART101', 'Beginning Basketweaving', 3.0);

  // Add these to the appropriate ArrayList.

  courseCatalog = [];
  courseCatalog.add(c1);
  courseCatalog.add(c2);
  courseCatalog.add(c3);
  courseCatalog.add(c4);
  courseCatalog.add(c5);

  // Establish some prerequisites (c1 => c2 => c3 => c4).

  c2.addPrerequisite(c1);
  c3.addPrerequisite(c2);
  c4.addPrerequisite(c3);

  // ---------
  // Sections.
  // ---------

  // Schedule sections of each Course by calling the
  // scheduleSection method of Course (which internally
  // invokes the Section constructor).

  sec1 = c1.scheduleSection('M', '8:10 - 10:00 PM', 'GOVT101', 30);
  sec2 = c1.scheduleSection('W', '6:10 - 8:00 PM', 'GOVT202', 30);
  sec3 = c2.scheduleSection('R', '4:10 - 6:00 PM', 'GOVT105', 25);
  sec4 = c2.scheduleSection('T', '6:10 - 8:00 PM', 'SCI330', 25);
  sec5 = c3.scheduleSection('M', '6:10 - 8:00 PM', 'GOVT101', 20);
  sec6 = c4.scheduleSection('R', '4:10 - 6:00 PM', 'SCI241', 15);
  sec7 = c5.scheduleSection('M', '4:10 - 6:00 PM', 'ARTS25', 40);

  // Add these to the Schedule of Classes.

  scheduleOfClasses.addSection(sec1);
  scheduleOfClasses.addSection(sec2);
  scheduleOfClasses.addSection(sec3);
  scheduleOfClasses.addSection(sec4);
  scheduleOfClasses.addSection(sec5);
  scheduleOfClasses.addSection(sec6);
  scheduleOfClasses.addSection(sec7);

  // Recruit a professor to teach each of the sections.

  p3.agreeToTeach(sec1);
  p2.agreeToTeach(sec2);
  p1.agreeToTeach(sec3);
  p3.agreeToTeach(sec4);
  p1.agreeToTeach(sec5);
  p2.agreeToTeach(sec6);
  p3.agreeToTeach(sec7);

  print('===============================');
  print('Student registration has begun!');
  print('===============================');
  print('');

  //
  // Simulate students attempting to enroll in sections of
		// various courses.

		print('Student ${s1.name} is attempting to enroll in ${sec1.toString()}');

		EnrollmentStatus status = sec1.enroll(s1);
		_reportStatus(status);

		// Note the use of a special 'housekeeping' method above, _reportStatus(), 
		// to interpret and display the outcome of this enrollment request.
		// We could have combined the preceding two lines with
		// a single line instead, as follows:
		//
		//	_reportStatus(sec1.enroll(s1));
		//
		// And, since the print() call just above that is also going to
		// be repeated multiple times, we could have combined ALL THREE 
		// LINES of code into a SINGLE line as follows:
		//
		//      _attemptToEnroll(s1, sec1);
		// 
		// by writing a more elaborate 'housekeeping' method, _attemptToEnroll().
	 	// We will, in fact, do so, and will use the more concise syntax for the 
		// remainder of this program.

		// Try concurrently enrolling the same Student in a different Section
		// of the SAME Course!  This should fail.

		_attemptToEnroll(s1, sec2);

		// This enrollment request should be fine ...

		_attemptToEnroll(s2, sec2);

		// ... but here, the student in question hasn't satisfied the
		// prerequisities, so the enrollment request should be rejected.

		_attemptToEnroll(s2, sec3);//TODO this is not failing, why?

		// These requests should both be fine. 

		_attemptToEnroll(s2, sec7);
		_attemptToEnroll(s3, sec1);

		// When the dust settles, here's what folks wound up
		// being SUCCESSFULLY registered for:
		//
		// sec1:  s1, s3
		// sec2:  s2
		// sec7:  s2

		// Semester is finished (boy, that was quick!).  
		// Professors assign grades for specific students.

		sec1.postGrade(s1, 'C+');
		sec1.postGrade(s3, 'A');
		sec2.postGrade(s2, 'B+');
		sec7.postGrade(s2, 'A-');
	
		// Let's see if everything got set up properly
		// by calling various display() methods.
		
		print('====================');
		print('Schedule of Classes:');
		print('====================');
		print('');
		scheduleOfClasses.display();

		print('======================');
		print('Professor Information:');
		print('======================');
		print('');
		p1.display();
		p2.display();
		p3.display();

		print('====================');
		print('Student Information:');
		print('====================');
		print('');
		s1.display();
		s2.display();
		s3.display();
}

// Note that this is a private static housekeeping method ...
void _reportStatus(EnrollmentStatus s) {
		print('Status:  ${enrollmentInfoMap[s]}');
		print('');
	}

  // ... as is this.

	void _attemptToEnroll(Student s, Section sec) {
		print('Student ${s.name} is attempting to enroll in ${sec.toString()}');
		// Utilize one housekeeping method from within another!
		_reportStatus(sec.enroll(s));
	}