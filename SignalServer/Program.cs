using Microsoft.AspNetCore.SignalR;

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

app.MapHub<MyHub>("/chat");

app.Run();

class MyHub : Hub
{
    public async IAsyncEnumerable<String> Streaming(CancellationToken cancellationToken)
    {
        while (true)
        {
            var flag = "A hora é " + DateTime.Now;
            yield return flag;
            await Task.Delay(1000, cancellationToken);
        }
    }
}