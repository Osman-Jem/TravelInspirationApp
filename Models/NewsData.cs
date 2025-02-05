using System;
using System.Collections.Generic;

namespace TravelInspiration.Models
{
    public class NewsData
    {
        public required string Status { get; set; }
        public required int TotalResults { get; set; }
        public required List<Article> Articles { get; set; }
    }

    public class Article
    {
        public required Source Source { get; set; }
        public required string Author { get; set; }
        public required string Title { get; set; }
        public required string Description { get; set; }
        public required string Url { get; set; }
        public required string UrlToImage { get; set; }
        public required DateTime PublishedAt { get; set; }
        public required string Content { get; set; }
    }

    public class Source
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
    }
}
