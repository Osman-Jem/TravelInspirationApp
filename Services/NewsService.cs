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
                // Lägg till User-Agent-header
                client.DefaultRequestHeaders.Add("User-Agent", "TravelInspirationApp/1.0"); // krävs av NewsAPI för att använda deras API

                var url = $"https://newsapi.org/v2/everything?q={cityEncoded}&pageSize=3&language=sv&apiKey={_apiKey}"; // Hämtar 3 nyhetsartiklar på svenska om staden
                var response = await client.GetAsync(url); // Hämtar data från API 

                if (response.IsSuccessStatusCode)
                {
                    var responseBody = await response.Content.ReadAsStringAsync();
                    var newsData = JsonConvert.DeserializeObject<NewsData>(responseBody);
                    return newsData?.Articles ?? new List<Article>(); // Returnerar en tom lista om inga artiklar hittades
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
