using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class Message
    {
        public int MessageId {get; set;}
        public string Username { get; set; } = "";
        public string MessageText { get; set; } = "";
        public DateTime MessageHour {get; set;}
    }
}
