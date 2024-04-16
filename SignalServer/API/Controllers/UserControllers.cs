using Microsoft.AspNetCore.Mvc;
using SignalServer.API.Hubs;

[ApiController]
[Route("api/[controller]")]
public class UserController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public UserController(ApplicationDbContext context){
        _context = context;
    }

    [HttpPost("loginAsync")]
    public IActionResult LoginAsync([FromBody] LoginDTO login)
    {
        var usuario = _context.Users.FirstOrDefault(a => a.UserName == login.Username && a.UserPassword == login.Password);

        if (usuario == null){
            return NotFound("Username ou senha não confere.");
        }
        else{
            return Ok(usuario);
        }
    }

    [HttpPost("registerAsync")]
    public async Task<IActionResult> RegisterAsync([FromBody] LoginDTO register)
    {
        int quantityAltered = 0;

            var usuario = _context.Users.FirstOrDefault(a => a.UserName == register.Username);

            if (usuario != null){
                return Conflict("Já existe um usuário com esse nome; tente novamente.");
            }

            Users novoUsuario = new Users { UserName = register.Username, UserPassword = register.Password};
            await _context.Users.AddAsync(novoUsuario);
            quantityAltered = await _context.SaveChangesAsync();

            if (quantityAltered > 0){
                return Ok("Usuário cadastrado.");
            }
            else{
                return Conflict("Não foi possível registrar esse usuário.");
            }
    }
}