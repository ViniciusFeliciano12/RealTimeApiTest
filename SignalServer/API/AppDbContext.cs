using Microsoft.EntityFrameworkCore;
using SignalServer.API.Hubs;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Users>().HasKey(u => u.UserID); // Especifica que a propriedade Id é a chave primária

        modelBuilder.Entity<UserMessages>()
        .HasKey(o => o.UserMessageId);

     modelBuilder.Entity<UserMessages>()
        .HasOne(m => m.User) // Relacionamento de um para um (uma mensagem pertence a um usuário)
        .WithMany() // Nenhum relacionamento inverso na entidade User
        .HasForeignKey(m => m.UserID); // Chave estrangeira na tabela Message
    }
    public DbSet<Users> Users { get; set; }
    public DbSet<UserMessages> UserMessages { get; set; }
}