namespace TravelInspiration.Models
{
    public class EventData
    {
        public required List<Event> Events { get; set; }
    }

    public class Event
    {
        public required string Title { get; set; }
        public required string Description { get; set; }
        public required Venue Venue { get; set; }
        public DateTime? DateTimeUtc { get; set; }
    }

    public class Venue
    {
        public required string Name { get; set; }
        public required string Address { get; set; }
        public required string City { get; set; }
    }
}
