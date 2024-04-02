using Microsoft.AspNetCore.SignalR.Client;
using System.Diagnostics;

namespace MauiTesteApp
{
    public partial class MainPage : ContentPage
    {
        private HubConnection? hubConnection;

        public MainPage()
        {
            InitializeComponent();
        }

        private async void OnCounterClicked(object sender, EventArgs e)
        {
            try
            {

                if (string.IsNullOrEmpty(entry.Text) || entry.Text.Count(t => t == '.') != 3)
                {
                    Hora.Text = "Endereço ip inválido, otário";
                    SemanticScreenReader.Announce(Hora.Text);
                    return;
                }

                var uri = $"http://{entry.Text}:5207/chat";

                hubConnection = new HubConnectionBuilder().
                    WithUrl(uri).
                    Build();

                await hubConnection.StartAsync();

                CounterBtn.IsVisible = false;
                CancelBtn.IsVisible = true;

                await foreach (var date in hubConnection.StreamAsync<String>("Streaming"))
                {
                    Hora.Text = date;
                    SemanticScreenReader.Announce(Hora.Text);
                }
            }
            catch (HttpRequestException ex)
            {
                Debug.WriteLine(ex.Message);
            }
        }

        private async void CancelBtn_Clicked(object sender, EventArgs e)
        {
            try
            {
                await hubConnection!.StopAsync();
                Hora.Text = "Operação cancelada";
                SemanticScreenReader.Announce(Hora.Text);
                CounterBtn.IsVisible = true;
                CancelBtn.IsVisible = false;
            }
            catch { }
            
        }
    }

}
