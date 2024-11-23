using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using WeatherApp.Models;

namespace WeatherApp.Services
{
    public class WeatherService
    {
        private readonly string _apiKey = "12a2d9b8d4316705b60d25e625cafc4c"; // Min API-nyckel från OpenWeatherMap

        public async Task<WeatherData> GetWeatherAsync(string stad)
        {
            var client = new HttpClient();
            var response = await client.GetAsync($"https://api.openweathermap.org/data/2.5/weather?q={stad}&appid={_apiKey}&units=metric");
            response.EnsureSuccessStatusCode();
            return JsonConvert.DeserializeObject<WeatherData>(await response.Content.ReadAsStringAsync());
        }
    }

    
}
