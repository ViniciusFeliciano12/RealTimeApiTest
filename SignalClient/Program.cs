using Microsoft.AspNetCore.SignalR.Client;

var uri = "http://192.168.0.7:5207/time";

await using var connection = new HubConnectionBuilder().WithUrl(uri).Build();

await connection.StartAsync();

await foreach (var date in connection.StreamAsync<String>("Streaming"))
{
    Console.WriteLine(date);
}