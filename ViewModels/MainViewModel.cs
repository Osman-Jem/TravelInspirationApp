using TravelInspiration.Models;
using System.Collections.Generic;

namespace TravelInspiration.ViewModels
{
    public class MainViewModel
    {
        public required string CityName { get; set; } // Stadens namn
        public required WeatherData Weather { get; set; } // Väderdata
        public required List<Article> News { get; set; } // Lista över nyhetsartiklar
        public required List<Event> Events { get; set; } // Eventdata
    }
}
