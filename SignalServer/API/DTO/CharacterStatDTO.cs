using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.DTO
{
    public class CharacterStatsDTO
    {                           
        public int CharacterLevel { get; set; }
        public Double Experience { get; set; }
        public int Points { get; set; }
        public int Strength { get; set; }
        public int Resistence { get; set; }
        public int Agility { get; set; }
        public int Inteligence { get; set; }
    }
}
