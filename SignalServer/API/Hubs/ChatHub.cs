using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    class ChatHub : Hub
    {
        public async Task SendMessage(string user, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", user, message);
        }
    }
}
