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
        messageHour = message.MessageHour.ToShortTimeString();
    }
}