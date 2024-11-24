namespace TravelInspiration.Models
{
    public class WeatherData
    {   
        public MainData Main { get; set; }
        public string Name { get; set; }
    }

    public class MainData
    {
        public float Temp { get; set; }
        public int Humidity { get; set; }
    }
}
