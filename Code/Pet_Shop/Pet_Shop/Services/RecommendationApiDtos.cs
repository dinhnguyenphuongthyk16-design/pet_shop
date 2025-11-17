using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Pet_Shop.Services
{
    public class RecommendationRequestDto
    {
        public string mode { get; set; } = "user";  // "user" | "click" | "text"

        public string? user_id { get; set; }

        public List<string>? history_item_keys { get; set; }
        public List<string>? clicked_item_keys { get; set; }
        public List<float>? click_weights { get; set; }

        public string? text_query { get; set; }

        public int k { get; set; } = 10;
    }

    public class RecommendationItemDto
    {
        [JsonPropertyName("item_id")]
        public int? item_id { get; set; }

        [JsonPropertyName("item_key")]
        public string? item_key { get; set; }

        [JsonPropertyName("source")]
        public string? source { get; set; }

        [JsonPropertyName("category")]
        public string? category { get; set; }

        [JsonPropertyName("size")]
        public string? size { get; set; }

        [JsonPropertyName("pet_type")]
        public string? pet_type { get; set; }

        [JsonPropertyName("name")]
        public string? name { get; set; }

        [JsonPropertyName("brand")]
        public string? brand { get; set; }

        [JsonPropertyName("score")]
        public float score { get; set; }
    }

    public class RecommendationApiResponseDto
    {
        [JsonPropertyName("recommendations")]
        public List<RecommendationItemDto> recommendations { get; set; } = new();

        [JsonPropertyName("success")]
        public bool success { get; set; }

        [JsonPropertyName("message")]
        public string? message { get; set; }
    }

    // For /health endpoint of Python API
    public class HealthResponseDto
    {
        public string? status { get; set; }
        public bool models_loaded { get; set; }
        public int n_items { get; set; }
        public bool item_only_loaded { get; set; }
    }
}
