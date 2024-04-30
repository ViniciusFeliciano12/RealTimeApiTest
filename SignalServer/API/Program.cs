using Microsoft.EntityFrameworkCore;
using SignalServer.API.Hubs;
using DotNetEnv;


var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSignalR();

builder.Services.AddControllers();

Env.Load();

string dbConnectionString = Env.GetString("DB_CONNECTION_STRING");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
        options.UseSqlServer(dbConnectionString));


builder.Services.AddCors(options =>
{
    options.AddPolicy(name: "CorsPolicy",
        policy =>
        {
            policy.AllowAnyHeader();
            policy.AllowAnyOrigin();
            policy.AllowAnyMethod();
        });
});

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("Errou otario");

    app.UseHsts();

    app.UseHttpsRedirection();
}

app.UseAuthorization();
app.UseCors("CorsPolicy");

app.UseRouting();
app.MapHub<MyHub>("/time");
app.MapHub<ChatHub>("/chat");
app.MapControllers();

app.Run();
