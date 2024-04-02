using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class Message
    {
        public string Username { get; set; } = "";
        public string MessageText { get; set; } = "";
    }
}
