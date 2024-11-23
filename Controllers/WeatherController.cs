using Microsoft.AspNetCore.Mvc;
using WeatherApp.Services;

namespace WeatherApp.Controllers;

public class WeatherController : Controller
{
    private readonly WeatherService _weatherService;

    public WeatherController(WeatherService weatherService)
    {
        _weatherService = weatherService;
    }

    public async Task<IActionResult> Index(string stad = "Gothenburg") // Tar emot "city" från formuläret
    {
        try
        {
            var weatherData = await _weatherService.GetWeatherAsync(stad); // Hämtar data för den angivna staden
            return View(weatherData); // Skickar data till vyn
        }
        catch (Exception ex)
        {
            // Hanterar fel, t.ex. om API-anropet misslyckas
            ViewBag.Error = $"Kunde inte hämta väderdata för {stad}. Kontrollera stavningen och försök igen.";
            return View(null); // Skickar en tom modell vid fel
        }
    }
}
