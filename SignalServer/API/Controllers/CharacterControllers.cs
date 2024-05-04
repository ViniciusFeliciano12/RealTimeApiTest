using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SignalServer.API.DTO;
using SignalServer.API.Hubs;

[ApiController]
[Route("character")]
public class CharacterControllers : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public CharacterControllers(ApplicationDbContext context){
        _context = context;
    }

    [HttpPost("createCharacterAsync")]
    public async Task<IActionResult> CreateCharacterAsync([FromBody] CharactersDTO newCharacter)
    {
        Characters novoPersonagem = new() 
        { 
            CharacterName = newCharacter.CharacterName,
            Age = newCharacter.Age, 
            Height = newCharacter.Height, 
            Superpower = newCharacter.Superpower, 
            UserID = newCharacter.UserID,
            AppearanceImage = newCharacter.AppearanceImage,
            WeaponImage = newCharacter.WeaponImage,
            CharacterStats = new()
            {
                Strength = newCharacter.Stats.Strength,
                Resistence = newCharacter.Stats.Resistence,
                Agility = newCharacter.Stats.Agility,
                Inteligence = newCharacter.Stats.Inteligence,
                Points = newCharacter.Stats.Points,
                CharacterLevel = newCharacter.Stats.CharacterLevel,
                Experience = newCharacter.Stats.Experience,
            }
        };

        await _context.Characters.AddAsync(novoPersonagem);
        int quantityAltered = await _context.SaveChangesAsync();
        
        return quantityAltered > 0 ? Ok("Personagem cadastrado.") : Conflict("Não foi possível registrar esse personagem.");
    }

    [HttpPost("editStatsCharacter")]
    public async Task<IActionResult> EditStatsCharacters([FromBody] NewCharacterStatsDTO newStats)
    {
        var character = _context.Characters.Where(a => a.CharacterID == newStats.CharacterID).Include(a => a.CharacterStats).FirstOrDefault();

        if (character == null){
            return Conflict("Character não existe.");
        }    

        character.CharacterStats!.Agility = newStats.Agility;
        character.CharacterStats.Strength = newStats.Strength;
        character.CharacterStats.Inteligence = newStats.Inteligence;
        character.CharacterStats.Resistence = newStats.Resistence;
        character.CharacterStats.Points = newStats.Points;

        _context.Characters.Update(character);
        int quantityAltered = await _context.SaveChangesAsync();

        return quantityAltered > 0 ? Ok("Personagem atualizado.") : Conflict("Não foi possível registrar esse personagem.");
    }

    [HttpGet("getAllCharacters")]
    public IActionResult GetAllCharacters([FromQuery] int userID)
    {
        var characters = _context.Characters.Where(a => a.UserID == userID).Include(a => a.CharacterStats).ToList();

        return characters.IsNullOrEmpty() ? Conflict("Não tem personagem registrado.") : Ok(characters);
    }

}