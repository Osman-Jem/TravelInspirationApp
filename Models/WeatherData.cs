namespace TravelInspiration.Models
{
    public class WeatherData
    {
        public required MainData Main { get; set; }
        public required string Name { get; set; }
    }

    public class MainData
    {
        public float Temp { get; set; }
        public int Humidity { get; set; }
    }
}
