using SignalServer.API.Hubs;

namespace SignalServer.API.DTO
{
    public class MessageHistoryDTO
    {
        public string Name { get; set; }
        public string Message { get; set; }
        public string MessageHour { get; set; }
        public bool NameVisible { get; set; } = true;

        public MessageHistoryDTO(UserMessages message)
        {
            Name = message.User!.UserName;
            Message = message.UserMessage;

            TimeSpan difference = DateTime.Today - message.MessageHour.Date;
            MessageHour = difference.Days switch
            {
                0 => $"Hoje às {message.MessageHour:HH:mm}",
                1 => $"Ontem às {message.MessageHour:HH:mm}",
                _ => $"{message.MessageHour:dd/MM/yyyy} às {message.MessageHour:HH:mm}",
            };
        }
    }
}