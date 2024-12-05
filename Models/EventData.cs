namespace TravelInspiration.Models
{
    public class EventData
    {
        public List<Event> Events { get; set; }
    }

    public class Event
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public Venue Venue { get; set; }
        public DateTime? DateTimeUtc { get; set; }
    }

    public class Venue
    {
        public string Name { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
    }
}
