import gmail
import datetime

def get_messages_from_gmail():
	g = gmail.login('username', 'password')
	g.mailbox('ITP').mail()
	messages = g.mailbox('ITP').mail(prefetch=True)
	message_list = list()
	for message in messages:
		message_list.append(message.subject + ", " + message.fr + ", " + message.thread_id)
	return message_list

mlist = get_messages_from_gmail()
for message in mlist:
	print message
