using Microsoft.AspNetCore.SignalR;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace SignalServer.API.Hubs
{
    class ChatHub : Hub
    {
        private readonly ApplicationDbContext _context;

        public ChatHub(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task CadastrarUsuario(string userName, string password)
        {
            int quantityAltered = 0;

            var usuario = _context.Usuarios.FirstOrDefault(a => a.Username == userName);

            if (usuario == null){
                await Clients.Caller.SendAsync("RegisterResponse", "Já existe um usuário com esse nome; tente novamente.");
                return;
            }

            User novoUsuario = new User { Username = userName, Password = password};
            await _context.AddAsync(novoUsuario);
            quantityAltered = await _context.SaveChangesAsync();
        

            if (quantityAltered > 0){
                await Clients.Caller.SendAsync("RegisterResponse", "Usuário cadastrado");
            }
            else{
                await Clients.Caller.SendAsync("RegisterResponse", "Usuário não registrado");
            }
        }

        public async Task SendMessage(string user, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", user, message, DateTime.Now.ToShortTimeString());
        }
    }
}
