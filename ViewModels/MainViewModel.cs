using TravelInspiration.Models;
using System.Collections.Generic;

namespace TravelInspiration.ViewModels
{
    public class MainViewModel
    {
        public string CityName { get; set; } // Stadens namn
        public WeatherData Weather { get; set; } // Väderdata
        public List<Article> News { get; set; } // Lista över nyhetsartiklar
    }
}
