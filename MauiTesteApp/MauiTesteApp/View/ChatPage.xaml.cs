using MauiTesteApp.Models;
using Microsoft.AspNetCore.SignalR.Client;
using System.Collections.ObjectModel;
using System.Diagnostics;

namespace MauiTesteApp.View;

public partial class ChatPage : ContentPage
{
    private HubConnection? hubConnection;
    public ObservableCollection<Message> messages { get; set; }


    public ChatPage()
	{
		InitializeComponent();

        messages = new ObservableCollection<Message>();

        listView.ItemsSource = messages;

        try
        {

            var uri = $"http://192.168.100.14:5207/chat";

            hubConnection = new HubConnectionBuilder().
            WithUrl(uri).
                Build();



            hubConnection.On<string, string, string>("ReceiveMessage", (user, message, hour) =>
            {
                messages.Add(new Message(user, message));

            });

            Task.Run(() =>
            {
                Dispatcher.Dispatch(async () =>
                {
                    await hubConnection.StartAsync();
                });
            });
           

        }
        catch (HttpRequestException ex)
        {
            Debug.WriteLine(ex.Message);
        }

    }

    private async void Button_Clicked(object sender, EventArgs e)
    {

        if (string.IsNullOrEmpty(entry.Text))
        {
            return;
        }

        await hubConnection!.InvokeCoreAsync("SendMessage", args: new[]
        {
            entry2.Text, 
            entry.Text
        });

        entry.Text = "";
    }

    private void Button_Clicked_1(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(entry2.Text))
        {
            return;
        }

        stack1.IsVisible = true;
        listView.IsVisible = true;
        stack2.IsVisible = false;

    }

    
}