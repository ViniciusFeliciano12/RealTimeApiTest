namespace SignalServer.API.Hubs
{
    public class Users
    {
        public int UserID { get; set; }
        public required string UserName { get; set; }
        public required string UserPassword { get; set; }
    }
}
