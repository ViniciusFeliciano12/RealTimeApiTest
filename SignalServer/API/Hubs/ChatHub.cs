using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class ChatHub : Hub
    {
        private readonly ApplicationDbContext _context;

        public ChatHub(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task CadastrarUsuario(string userName, string password)
        {
            int quantityAltered = 0;

            var usuario = _context.Users.FirstOrDefault(a => a.UserName == userName);

            if (usuario != null){
                await Clients.Caller.SendAsync("RegisterResponse", "Já existe um usuário com esse nome; tente novamente.");
                return;
            }

            Users novoUsuario = new Users { UserName = userName, UserPassword = password};
            await _context.Users.AddAsync(novoUsuario);
            quantityAltered = await _context.SaveChangesAsync();

            if (quantityAltered > 0){
                await Clients.Caller.SendAsync("RegisterResponse", "Usuário cadastrado");
            }
            else{
                await Clients.Caller.SendAsync("RegisterResponse", "Usuário não registrado");
            }
        }

        public async Task Login(string userName, string password)
        {
            var usuario = _context.Users.FirstOrDefault(a => a.UserName == userName && a.UserPassword == password);

            if (usuario == null){
                await Clients.Caller.SendAsync("LoginResponse", "Username ou senha não confere.");
                return;
            }
            else{
                await Clients.Caller.SendAsync("LoginResponse", usuario);
            }
        }

        public async Task SendMessage(int userId, string user, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", user, message, DateTime.Now.ToShortTimeString());
            UserMessages newMessage = new UserMessages();
            newMessage.UserID = userId;
            newMessage.MessageHour = DateTime.Now;
            newMessage.UserMessage = message;

            _context.UserMessages.Add(newMessage);
            await _context.SaveChangesAsync();
        }
    }
}
