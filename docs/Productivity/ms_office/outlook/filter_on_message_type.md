# Filter on message type
Sometimes it is handy to filter on meeting invites for example. In the desktop version of
Outlook you can do that.

Source: 

* https://superuser.com/questions/555304/how-to-search-for-item-type-in-outlook
* Link to exact post: https://superuser.com/a/713419

!!! quote "Full answer from [hotshot309](https://superuser.com/users/174139/hotshot309)"
    In the search box, include `messageclass:IPM.Note` to find only e-mail messages.

    Here is the full list (as far as I know) of message classes for Outlook/Exchange 2010 items. 
    I found some of this information in Mastering Microsoft Exchange Server 2010 by Jim McBee and David Elfassy. 
    I found the rest by adding the "Message Class" column to an Outlook folder view and noting the values for different types of messages in that folder.
    
    * **IPM.Activity:** Item in Outlook Journal folder
    * **IPM.Appointment:** Item on Outlook Calendar
    * **IPM.Contact:** Item in Outlook Contacts folder
    * **IPM.Document:** Document/file (I don't believe this filter would ever yield results when searching Outlook e-mail)
    * **IPM.Note:** E-mail message
    * **IPM.Note.Rules.OofTemplate.Microsoft:** Received out-of-office auto reply e-mail
    * **IPM.Note.SMIME:** Encrypted or digitally signed e-mail message
    * **IPM.Note.Microsoft.Conversation:** Office Communication Server instant message or group chat session
    * **IPM.Note.Microsoft.Conversation.Voice:** Office Communication Server call
    * **IPM.Note.Microsoft.Fax:** Fax message
    * **IPM.Note.Microsoft.Missed.Voice:** Notice of missed Office Communication Server call
    * **IPM.Post:** Internet post item, usually for a public folder (I am unfamiliar with this one)
    * **IPM.Post.RSS:** RSS feed
    * **IPM.Schedule:** Meeting-related notice (will catch all of the specific types below)
    * **IPM.Schedule.Meeting.Canceled:** Meeting cancellation notice
    * **IPM.Schedule.Meeting.Notification.Forward:** Forwarded meeting invitation
    * **IPM.Schedule.Meeting.Request:** New or updated received meeting invitation
    * **IPM.Schedule.Meeting.Resp.Neg:** Sent declined meeting notice
    * **IPM.Schedule.Meeting.Resp.Pos:** Sent accepted meeting notice
    * **IPM.Schedule.Meeting.Resp.Tent:** Sent tentative meeting notice
    * **IPM.StickyNote:** Item in Outlook Notes folder
    * **IPM.Task:** Item in Outlook Tasks folder
    * **IPM.Note.Microsoft.Voicemail:** Voicemail left via Exchange 2007 Unified Messaging server or equivalent
    * **IPM.Sharing:** The Sharing Message Object Protocol is used to share mailbox folders between clients. This protocol extends the Message and Attachment Object Protocol.