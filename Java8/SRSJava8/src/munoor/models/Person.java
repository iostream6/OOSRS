/*
 * 2020.11.26  - Created
 */
package munoor.models;

/**
 *
 * @author Ilamah, Osho
 */
public abstract class Person {
    //------------
    // Attributes.
    //------------

    private String name;
    private String ssn;

    //----------------
    // Constructor(s).
    //----------------
    public Person(String name, String ssn) {
        this.setName(name);
        this.setSsn(ssn);
    }

    public Person() {
        this.setName("?");
        this.setSsn("???-??-????");
    }

    //------------------
    // Accessor methods.
    //------------------
    public String getName() {
        return name;
    }

    public final void setName(String name) {
        this.name = name;
    }

    public String getSsn() {
        return ssn;
    }

    public final void setSsn(String ssn) {
        this.ssn = ssn;
    }

    //-----------------------------
    // Miscellaneous other methods.
    //-----------------------------
    // We'll let each subclass determine how it wishes to be
    // represented as a String value.
    @Override
    public abstract String toString();

    public void display() {
        System.out.println("Person Information:");
        System.out.println("\tName:  " + this.getName());
        System.out.println("\tSoc. Security No.:  " + this.getSsn());
    }

}
