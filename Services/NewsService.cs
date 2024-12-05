using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using TravelInspiration.Models;
using System.Collections.Generic;

namespace TravelInspiration.Services
{
    public class NewsService
    {
        private readonly string _apiKey = "713ea2ea7bd54971b20489005161dde9"; // Min API-nyckel från NewsAPI

        public async Task<List<Article>> GetNewsAsync(string city)
        {
            var cityEncoded = Uri.EscapeDataString(city);

            using (var client = new HttpClient())
            {
                // Lägg till User-Agent-header (ChatGPT)
                client.DefaultRequestHeaders.Add("User-Agent", "TravelInspirationApp/1.0");

                var url = $"https://newsapi.org/v2/everything?q={cityEncoded}&pageSize=3&language=sv&apiKey={_apiKey}"; // Hämtar 3 nyhetsartiklar på svenska om staden

                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var responseBody = await response.Content.ReadAsStringAsync();
                    var newsData = JsonConvert.DeserializeObject<NewsData>(responseBody);
                    return newsData.Articles;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    throw new Exception($"API Error: {response.StatusCode} - {errorContent}");
                }
            }
        }
    }
}
