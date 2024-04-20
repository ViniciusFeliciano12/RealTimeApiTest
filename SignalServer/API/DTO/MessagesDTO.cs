using SignalServer.API.Hubs;

public class MessageHistoryDTO
{
    public string name { get; set; }
    public string message { get; set; }
    public string messageHour { get; set; }
    public bool nameVisible { get; set; } = true;

    public MessageHistoryDTO(UserMessages message){
        name = message.User!.UserName;
        this.message = message.UserMessage;

        TimeSpan difference = DateTime.Today - message.MessageHour.Date;
        switch (difference.Days)
        {
            case 0:
                messageHour = $"Hoje às {message.MessageHour:HH:mm}";
                break;
            case 1:
                messageHour = $"Ontem às {message.MessageHour:HH:mm}";
                break;
            default:
                messageHour = $"{message.MessageHour:dd/MM/yyyy} às {message.MessageHour:HH:mm}";
                break;
        }
    }
}