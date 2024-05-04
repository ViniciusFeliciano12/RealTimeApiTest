using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SignalServer.API.Hubs;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public string HashPassword(string password)
    {
        byte[] hashedBytes = SHA256.HashData(Encoding.UTF8.GetBytes(password));

        StringBuilder builder = new();
        for (int i = 0; i < hashedBytes.Length; i++)
        {
            builder.Append(hashedBytes[i].ToString("x2"));
        }

        return builder.ToString();
    }


    public UserController(ApplicationDbContext context){
        _context = context;
    }

    [HttpPost("loginAsync")]
    public IActionResult LoginAsync([FromBody] LoginDTO login)
    {
        var usuario = _context.Users.FirstOrDefault(a => a.UserName == login.Username && a.UserPassword == 
        HashPassword(login.Password));

        usuario!.UserPassword = "censurada";
        return usuario == null ? NotFound("Username ou senha não confere.") : Ok(usuario);
    }

    [HttpPost("registerAsync")]
    public async Task<IActionResult> RegisterAsync([FromBody] LoginDTO register)
    {
        var usuario = _context.Users.FirstOrDefault(a => a.UserName == register.Username);

        if (usuario != null){
            return Conflict("Já existe um usuário com esse nome; tente novamente.");
        }

        Users novoUsuario = new() { UserName = register.Username, UserPassword = HashPassword(register.Password)};
        await _context.Users.AddAsync(novoUsuario);
        int quantityAltered = await _context.SaveChangesAsync();

        return quantityAltered > 0 ? Ok("Usuário cadastrado.") :  Conflict("Não foi possível registrar esse usuário.");
    }

    [HttpGet("getMessageHistory")]
    public IActionResult MessageHistory()
    {
        var messages = _context.UserMessages.Include(a => a.User).ToList();

        List<MessageHistoryDTO> historic = [];

        if (messages.Count > 0){
            var lastMessage = messages[0];
            bool first = true;
            foreach(var msg in messages){
                var msgs = new MessageHistoryDTO(msg);
                if (!first && msgs.name == lastMessage.User!.UserName){
                    msgs.nameVisible = false;
                }
                historic.Add(msgs);
                first = false;
                lastMessage = msg;
            }
        }
        return Ok(historic);
    }
}