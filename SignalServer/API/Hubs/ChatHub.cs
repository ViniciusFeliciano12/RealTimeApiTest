using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class ChatHub(ApplicationDbContext context) : Hub
    {
        private readonly ApplicationDbContext _context = context;

        public async Task SendMessage(int userId, string user, string message)
        {
            var hora = DateTime.Now.ToShortTimeString();
            await Clients.All.SendAsync("ReceiveMessage", user, message, $"Hoje às {hora}");
            UserMessages newMessage = new()
            {
                UserID = userId,
                MessageHour = DateTime.Now,
                UserMessage = message
            };
            _context.UserMessages.Add(newMessage);
            await _context.SaveChangesAsync();
        }
    }
}
