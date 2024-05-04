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

        modelBuilder.Entity<UserMessages>().HasKey(o => o.UserMessageId);

        modelBuilder.Entity<UserMessages>()
            .HasOne(m => m.User) // Relacionamento de um para um (uma mensagem pertence a um usuário)
            .WithMany() // Nenhum relacionamento inverso na entidade User
            .HasForeignKey(m => m.UserID); // Chave estrangeira na tabela Message

        modelBuilder.Entity<Characters>().HasKey(o => o.CharacterID);

        modelBuilder.Entity<Characters>()
            .HasOne(m => m.User) 
            .WithMany()
            .HasForeignKey(m => m.UserID); 

            modelBuilder.Entity<Characters>()
            .HasOne(m => m.CharacterStats) 
            .WithMany()
            .HasForeignKey(m => m.StatsID); 
        
        modelBuilder.Entity<CharacterStats>().HasKey(o => o.StatsID);

    }
    public DbSet<Users> Users { get; set; }
    public DbSet<UserMessages> UserMessages { get; set; }
    public DbSet<Characters> Characters { get; set; }
    public DbSet<CharacterStats> CharacterStats { get; set; }

}