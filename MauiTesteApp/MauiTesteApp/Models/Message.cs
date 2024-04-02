namespace MauiTesteApp.Models
{
    public class Message
    {
        public string Username { get; set; }
        public string MessageText { get; set; }

        public Message(string username, string messageText)
        {
            Username = username;
            MessageText = messageText;
        }

    }
}
