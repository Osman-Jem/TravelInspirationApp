using Microsoft.AspNetCore.Mvc;
using TravelInspiration.Services;
using TravelInspiration.ViewModels;

namespace TravelInspiration.Controllers
{
    public class MainController : Controller
    {
        private readonly WeatherService _weatherService;
        private readonly NewsService _newsService;

        public MainController(WeatherService weatherService, NewsService newsService)
        {
            _weatherService = weatherService;
            _newsService = newsService;
        }

        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Index(MainViewModel model)
        {
            if (string.IsNullOrEmpty(model.CityName))
            {
                model.CityName = "Göteborg"; // Standard om inget anges
            }

            try
            {
                var weatherData = await _weatherService.GetWeatherAsync(model.CityName);
                model.Weather = weatherData;

                var newsData = await _newsService.GetNewsAsync(model.CityName);
                model.News = newsData;
            }
            catch (Exception ex)
            {
                ViewBag.ErrorMessage = $"Error fetching data: {ex.Message}";
            }

            return View(model);
        }
    }
}
