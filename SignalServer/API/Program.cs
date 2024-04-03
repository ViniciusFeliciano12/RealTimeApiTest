using Microsoft.AspNetCore.SignalR;
using Microsoft.OpenApi.Models;
using SignalServer.API.Hubs;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSignalR();

builder.Services.AddControllersWithViews();

builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo { Title = "Some API v1", Version = "v1" });
    options.AddSignalRSwaggerGen();
});

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

