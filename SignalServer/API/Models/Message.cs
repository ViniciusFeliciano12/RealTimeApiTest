using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class UserMessages
    {
        public int UserMessageId { get; set; }
        public required string UserMessage { get; set; }
        public DateTime MessageHour { get; set; }
        public int UserID { get; set; }
        public Users? User { get; set; }
    }
}
