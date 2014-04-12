// Create a Sender Object for all the students at ITP. Each Sender Object has an IntList of students
// to keep track of conversation count

class Sender {

  String studentName;
  int year;

  IntDict students;

  // Each Sender Object in Hashmap gets Pvector to position on Circle Network Visualization
  PVector pos = new PVector();
  float rot = 0;

  Sender(String n, int y) {

    studentName = n;
    year = y;
  }   

  void addConversation(String n) {
    students.increment(n);
  }

  void createIntDict() {
    students = new IntDict();

    for (TableRow row : allStudents.rows()) {
      String n = row.getString("name");
      students.set(n, 0);
    }
  }

  void createNetwork() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotateZ(rot);
    fill(240);
    ellipse(0, 0, 3, 3);
    textSize(10);
    text(studentName, 5, 5);
    popMatrix();
  }

  void createLinks() {

    // Create Links between Students in same thread
    String[] keys = students.keyArray();
    int[] values = students.valueArray();
    //    Sender s = new Sender(studentName, year);

    for (int i = 0; i < keys.length; i++) {
      if (keys[i] != this.studentName) {
        Sender s = studentList.get(keys[i]);
        if (values[i] != 0) {
          // Map the thickness of the Line
          float thickness = map(values[i], 1, 21, .1, 10);
          // Map the Alpha of the Line
          float alpha = map(values[i], 1, 21, 0, 80);
          strokeWeight(thickness);

          stroke(210, alpha);
          line(pos.x, pos.y, s.pos.x, s.pos.y);
        }
      }
    }
  }
}

