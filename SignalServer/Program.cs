using Microsoft.AspNetCore.SignalR;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddSignalR();

var app = builder.Build();

app.MapHub<MyHub>("/chat");
app.Run();


class MyHub : Hub
{
    public async IAsyncEnumerable<String> Streaming(CancellationToken cancellationToken)
    {
        while (true)
        {
            var flag = "A hora é " + DateTime.UtcNow;
            yield return flag;
            await Task.Delay(1000, cancellationToken);
        }
    }
}