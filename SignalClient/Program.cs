using Microsoft.AspNetCore.SignalR.Client;

namespace ChatApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var uri = "http://192.168.0.12:5207/chat";

            var connection = new HubConnectionBuilder().WithUrl(uri).Build();

            connection.On<string>("RegisterResponse", (response) =>
            {
                Console.WriteLine(response);
            });

            try
            {
                await connection.StartAsync();
                Console.WriteLine("Conectado ao servidor SignalR!");

                // Mantém a aplicação aberta para enviar e receber mensagens
                while (true)
                {
                    var nome = Console.ReadLine();
                    var senha = Console.ReadLine();

                    // Verifica se o usuário digitou 'exit' para sair do loop
                    if (nome?.ToLower() == "exit" || senha?.ToLower() == "exit" )
                        break;

                    // Envia a mensagem para o servidor
                    await connection.InvokeAsync("CadastrarUsuario", nome, senha);
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