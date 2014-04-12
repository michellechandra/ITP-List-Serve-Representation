// Create an EmailThread object to store Email Threads

class EmailThread {
  String id;
  // Thread object sorted by thread id, all the people go into thread object
  // If I need a list of the same thing, make an array list 
  ArrayList<String> senders;

  // my EmailThread object has a string s
  EmailThread(String s) {

    // The string s equals the thread id
    id = s;

    // For every thread id, make a sender arraylist
    senders = new ArrayList<String>();
  } 

  // Add senders to array list
  void addSender(String sender) {
    if (!senders.contains(sender)) {
      senders.add(sender);
    }
  }
}

