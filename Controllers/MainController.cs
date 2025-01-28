using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using TravelInspiration.Services;
using TravelInspiration.ViewModels;

namespace TravelInspiration.Controllers
{
    public class MainController : Controller
    {
        private readonly WeatherService _weatherService;
        private readonly NewsService _newsService;
        private readonly EventService _eventService;

        public MainController(WeatherService weatherService, NewsService newsService, EventService eventService)
        {
            _weatherService = weatherService;
            _newsService = newsService;
            _eventService = eventService;
        }

        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Index(MainViewModel model)
        {
            if (string.IsNullOrEmpty(model.CityName))
            {
                model.CityName = "Göteborg"; // Standard om ingen annan stad anges
            }

            try
            {
                model.Weather = await _weatherService.GetWeatherAsync(model.CityName);
                model.News = await _newsService.GetNewsAsync(model.CityName);
                model.Events = await _eventService.GetEventAsync(model.CityName);
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = $"Error fetching data: {ex.Message}";
            }

            return View(model);
        }
    }
}
