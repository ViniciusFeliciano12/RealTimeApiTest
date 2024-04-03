using Microsoft.AspNetCore.SignalR.Client;

namespace ChatApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var uri = "http://26.159.154.197:5207/chat";

            var connection = new HubConnectionBuilder().WithUrl(uri).Build();

            connection.On<string, string>("ReceiveMessage", (user, message) =>
            {
                Console.WriteLine($"usuário: {user}, mensagem: {message}");
            });

            try
            {
                await connection.StartAsync();
                Console.WriteLine("Conectado ao servidor SignalR!");

                // Mantém a aplicação aberta para enviar e receber mensagens
                while (true)
                {
                    var input = Console.ReadLine();

                    // Verifica se o usuário digitou 'exit' para sair do loop
                    if (input?.ToLower() == "exit")
                        break;

                    // Envia a mensagem para o servidor
                    await connection.InvokeAsync("SendMessage", "bibi e um viado", input);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Erro ao conectar ao servidor: {ex.Message}");
            }
            finally
            {
                await connection.DisposeAsync();
            }
        }
    }
}