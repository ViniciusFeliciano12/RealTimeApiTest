using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
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
}
