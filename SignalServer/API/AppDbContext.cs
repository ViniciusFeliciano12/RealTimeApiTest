using Microsoft.EntityFrameworkCore;
using SignalServer.API.Hubs;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Usuarios { get; set; }
    public DbSet<Message> Mensagens { get; set; }
}