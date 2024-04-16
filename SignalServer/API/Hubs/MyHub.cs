using Microsoft.AspNetCore.SignalR;
using SignalRSwaggerGen.Attributes;

namespace SignalServer.API.Hubs
{
    [SignalRHub]
    class MyHub : Hub
    {
        public async IAsyncEnumerable<String> Streaming()
        {
            while (true)
            {
                var flag = "A hora é " + DateTime.Now;
                yield return flag;
                await Task.Delay(1000);
            }
        }
}
}
