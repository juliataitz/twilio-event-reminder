###What do we want to do?

Send important text message reminders when you sign up through facebook.

###How are we doing this? 

An Event (organized events or birthdays) is considered important, if people who are close to you are participating.

For now there could be three different ways of figuring out why someone is important to you

1. You literally select the people who are important to you.
2. We use Facebooks friends lists like Family, close Friends, etc. to tell who's important and who isn't.
3. We use Facebooks relationship algorithm to know who you like/stalk/is important to you.

###What are we going to use?

- OAuth 2.0 (Facebook login)
- Facebook API (determin important people)
- Twilio API (send out sms reminders)

#####More technical solutions for getting close friends through User attributes

- User/{user-id}/significant-other
- User/{user-id}/family 
- User/{user-id}/friendlists
- User/{user-id}/pokes

There should be a table for the users statuses:

table User has_many :statuses
table Status belongs_to :user

statuses should have these columns

- user_id (will allow relationship to user)
- content (will store the message of todays status)
- time of creation (will tell Twilio when to send out the message)

Features:

- choose to get status updates from three years ago
- choose to get either 2 weeks, 4 weeks, or three months worth of status updates. Or a year. 
  this could be set up in funny payment plans like all the hot companies have these days. 
  The fourth plan could be a enterprise plan
- The site will also have to be responsive so people can sign up using their smartphones. 

###Every Day:

collect_content_for_scheduling()
  - request_user_statuses()
  - 
  - store_todays_message() <- may not be necessary
  - create_message_hash()
    - select_shortest_message()


schedule_content()

message_hash = {
  
  :author => "Julia", #there should be a method to just get the first name
  :content => "OMG I LOOOOOOVE JUSTIN BEIBER, HE'S THE BEST!!!!",
  :time => "2013-06-13T04:03:02+0000"

}


*random thoughts*

One way to not store a lot in our database is to not store each statuses/posts id. Instead just store an integer that increments. Because the order of statuses/posts of the past will not change, it will be easy to just run the sorting every time and just keep track of how often it's run so far. Then just take that incrementer and ignore incrementer*statuses of the beginning of our statuses array. This way we will not have to store anything in our database.

Maybe statuses and posts should be treated equal and just the amount of likes should count.

If we'd truly select randomly, we'd definitely have to keep track in our database of what has been sent to the user. But if we have a system that sorts all their posts/statuses instead, we can just assign another column in the user table that keeps track of how many messages have been sent to the user.


























