using Microsoft.AspNetCore.SignalR.Client;

var uri = "http://localhost:5207/chat";

await using var connection = new HubConnectionBuilder().WithUrl(uri).Build();

await connection.StartAsync();

await foreach (var date in connection.StreamAsync<String>("Streaming"))
{
    Console.WriteLine(date);
}