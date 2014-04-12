/*
 Michelle Chandra
 NYU - ITP, April 2014
 michelle.chandra@gmail.com
 
 This Processing sketch creates a network visualization of the ITP List-Serve based on public emails. 
 
 The data file is not included to protect the privacy of ITP students. However, any data set can be swapped 
 in as long as the data file has the following information: thread ID #, name of sender, subject line
 
 */

Table allStudents;  // ClassList Table
Table table;  // ITP List Serve Data Table
HashMap<String, Sender> studentList = new HashMap<String, Sender>(); // Hashmap of Sender Objects
ArrayList<Sender> sortedStudents = new ArrayList<Sender>(); // ArrayList of Sender Objects
ArrayList<Sender> sortedSecondStudents = new ArrayList<Sender>(); // First Year Sorted ArrayList of Sender Objects
ArrayList<Sender> sortedFirstStudents = new ArrayList<Sender>(); // Second Year Sorted ArrayList of Sender Objects
HashMap<String, EmailThread> threads = new HashMap<String, EmailThread>(); // Create a Hashmap of Email Threads
int i = 0;

void setup() {
  size(1200, 1000, P3D);
  background(80);

  // Load my Tables  //
  allStudents = loadTable("classlist.csv", "header");
  table = loadTable("python-data-4.csv", "header");

  senderHash(); // Create a Hashmap of Senders
  emailThreadHash(); // Create a Hashmap of Email Threads
  parseEmails(); // Count number of times Sender is in conversation with other senders
  arrangeStudents(); // Arrange Students in Circle
}

void senderHash() {

  // Create a Hashmap of Sender Objects. 
  // The Key is the Name of the Student, the Value is the year

  for (TableRow row : allStudents.rows()) {

    String n = row.getString("name");
    int y = row.getInt("year");

    // Check to see if my Hashmap contains my student from the ClassList
    if (!studentList.containsKey(n)) {

      // If the Hashmap doesn't contain the student, create a new Sender Object to store the student
      Sender s = new Sender(n, y);

      // Add Sender Object to my Hashmap
      studentList.put(n, s);

      // Also add my Sender Objects to ArrayList, dependent on class year
      if (s.year==1)
        sortedFirstStudents.add(s);

      else if (s.year==2)
        sortedSecondStudents.add(s);
    }
  }

  // Create new ArrayList by adding FirstYear ArrayList to SecondYear ArrayList
  for (Sender s:sortedFirstStudents) {
    sortedStudents.add(s);
  }

  for (Sender s:sortedSecondStudents) {
    sortedStudents.add(s);
  }

  // Add the ConversationIntDict to Senders stored in Hashmap 
  for (Sender s : sortedStudents) {
    s.createIntDict();
  }
}


void emailThreadHash() {

  // Create Hashmap of Email Threads and associated senders
  // Get the ID and Sender strings from my Email Data Table 
  for (TableRow row : table.rows()) {
    String id = row.getString("id");
    String sender = row.getString("sender");

    // Iterate through my Email Thread Hashmap
    // If the Thread ID is not in my Email Thread Hashmap, create a new Email Thread object and put in my Hashmap - add Sendors
    if (!threads.containsKey(id)) {
      EmailThread thread = new EmailThread(id);
      thread.addSender(sender);
      threads.put(id, thread);
    } 
    else {

      // If the hashmap already has the Thread ID, add the senders
      EmailThread thread = threads.get(id);
      thread.addSender(sender);
    }
  }
}

void parseEmails() {

  // Iterate through my Email Thread Hashmap and increase the conversation count of Senders

    for (EmailThread thread : threads.values()) {

    // Look up each sender in each Thread
    for (String name : thread.senders) {

      // Look up the matching Sender in my Sender Hashmap
      // If the sender in the Email Thread IS in my Sender Hashmap, then add to IntDict (if only)
      if (studentList.containsKey(name)) {
        Sender s = studentList.get(name);
        //println(name);
        // Increment the Intdict in my Sender object
        for (String other : thread.senders) {
          if (studentList.containsKey(other)) {
            s.addConversation(other);
          }
        }
      }
    }
  }
}

void arrangeStudents() {

  // Arrange students in circle network visualization
  for (Sender s :sortedStudents ) {

    // 0-Tau is One Revolution around the circle 
    // PI is only 1/2 of circle
    // -TAU/4 changes it by 90 degrees (subtract 90 degrees from where it starts and ends)

    float theta = map(i, 0, studentList.size(), -TAU/4, 3*TAU/4);
    float rad = 350;
    s.rot = theta;
    s.pos.x = cos(theta) * rad;
    s.pos.y = sin(theta) * rad;
    i++;
  }
}

void draw() {  
  background(80);
  translate(width/2, height/2);  // Draw Network Visualization in Center of Screen

  for (Sender s : sortedStudents) {
    s.createNetwork();  // Draw Sender Network in Circle
    s.createLinks();  // Draw conversation links between students
  }
}

