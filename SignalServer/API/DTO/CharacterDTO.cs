using Microsoft.AspNetCore.SignalR;

namespace SignalServer.API.DTO
{
    public class CharactersDTO
    {
        public int UserID { get; set; }
        public required string CharacterName { get; set; }
        public int Age { get; set; }
        public float Height { get; set; }
        public required string Superpower { get; set; }
        public required string AppearanceImage { get; set; }
        public required string WeaponImage { get; set; }
        public required CharacterStatsDTO Stats { get; set; }
    }
}
