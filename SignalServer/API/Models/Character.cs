using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.Hubs
{
    public class Characters
    {
        public int CharacterID { get; set;}
        public int UserID { get; set; }
        public Users? User { get; set; }
        public int StatsID { get; set;}
        public CharacterStats? CharacterStats { get; set; }
        public required string CharacterName { get; set; }
        public int Age { get; set; }
        public Double Height { get; set; }
        public required string Superpower { get; set; }
        public required string AppearanceImage { get; set; }
        public required string WeaponImage { get; set; }
    }
}
