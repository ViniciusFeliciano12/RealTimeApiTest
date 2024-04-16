using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class UserMessages
    {
        public int UserMessagesId {get; set;}
        public string UserMessage { get; set; } = "";
        public DateTime MessageHour {get; set;}
        public int UserID { get; set; }
        public Users? User {get; set;}
    }
}
