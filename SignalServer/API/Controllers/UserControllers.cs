using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SignalServer.API.DTO;
using SignalServer.API.Hubs;

[ApiController]
[Route("api/[controller]")]
public class UserController(ApplicationDbContext context) : ControllerBase
{
    private readonly ApplicationDbContext _context = context;

    [HttpPost("loginAsync")]
    public IActionResult LoginAsync([FromBody] LoginDTO login)
    {
        var usuario = _context.Users.FirstOrDefault(a => a.UserName == login.Username &&
         a.UserPassword == Utils.HashPassword(login.Password));

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

        Users novoUsuario = new() { UserName = register.Username, UserPassword = Utils.HashPassword(register.Password)};
        await _context.Users.AddAsync(novoUsuario);
        int quantityAltered = await _context.SaveChangesAsync();

        return quantityAltered > 0 ? Ok("Usuário cadastrado.") :  Conflict("Não foi possível registrar esse usuário.");
    }

    [HttpGet("getMessageHistory")]
    public IActionResult MessageHistory()
    {
        var messages = _context.UserMessages.Include(a => a.User).ToList();

        var historic = messages.Select((message, index) =>
        {
            var msgs = new MessageHistoryDTO(message)
            {
                NameVisible = index == 0 || message.User!.UserName != messages[index - 1].User!.UserName ||
                 message.MessageHour.Day != messages[index - 1].MessageHour.Day,
            };
            return msgs;
        }).ToList();

        return Ok(historic);
    }
}