using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Collections.Generic;
using TravelInspiration.Models;

namespace TravelInspiration.Services
{
    public class EventService
    {
        private readonly string _clientID = "NDcyNjg4Mzh8MTczMzMyOTgwMS43Mjk1MDQ4"; // Min SeatGeek TravelInspirationApp ClientID.

        public async Task<List<Event>> GetEventAsync(string city)
        {
            using (var client = new HttpClient())
            {
                var url = $"https://api.seatgeek.com/2/events?venue.city={city}&client_id={_clientID}";
                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var responseBody = await response.Content.ReadAsStringAsync();
                    var eventData = JsonConvert.DeserializeObject<EventData>(responseBody);
                    return eventData.Events;
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
