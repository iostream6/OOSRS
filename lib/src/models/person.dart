/*
 * 2020.11.25  - Created | Translate complete
 */

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
