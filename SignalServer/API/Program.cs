using Microsoft.AspNetCore.SignalR;
using SignalServer.API.Hubs;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSignalR();

builder.Services.AddControllersWithViews();

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

if (!app.Environment.IsDevelopment()){
    app.UseExceptionHandler("Errou otario");

    app.UseHsts();

    app.UseHttpsRedirection();
}

app.UseRouting();

app.UseAuthorization();

app.UseCors("CorsPolicy");

app.MapHub<MyHub>("/time");
app.MapHub<ChatHub>("/chat");

app.Run();

