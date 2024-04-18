using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace FakeIISLogGenerator
{
    public class FakeIISLogGenerator
    {
        private static DateTime startingDateTime = new DateTime(2024, 9, 1, 0, 0, 0); // Starting point
        private static Random rand = new Random();

        public static void Main(string[] args)
        {
            // Path to save the generated fake IIS log
            string filePath = "fakeIISLog.txt";

            // Generate and save fake log entries
            GenerateFakeIISLog(filePath, 100000); // Generating 100 fake log entries
        }

        private static void GenerateFakeIISLog(string filePath, int numberOfEntries)
        {
            using (StreamWriter writer = new StreamWriter(filePath))
            {
                DateTime currentDateTime = startingDateTime;

                for (int i = 0; i < numberOfEntries; i++)
                {
                    // Generate a fake log entry
                    string logEntry = GenerateLogEntry(ref currentDateTime);

                    // Write the fake log entry to file
                    writer.WriteLine(logEntry);
                }
            }
        }
        private static string GenerateLogEntry(ref DateTime currentDateTime)
        {           
            // Increment currentDateTime by a random amount of time (e.g., 1 to 60 seconds)
            currentDateTime = currentDateTime.AddSeconds(rand.Next(1, 100));

            // Formatting the dateTime for the log entry
            string dateTime = currentDateTime.ToString("yyyy-MM-dd HH:mm:ss");

            // Generating a fake client IP
            string clientIP = $"{rand.Next(1, 256)}.{rand.Next(0, 256)}.{rand.Next(0, 256)}.{rand.Next(0, 256)}";

            // Randomly choosing between GET and POST methods
            string method = rand.Next(3) == 0 ? "POST" : "GET";

            string urlPath = GenerateUrlPath(currentDateTime); // Generate path based on time of day and popularity

            // Adding a query parameter for dynamic resources
            if (method == "GET" && rand.Next(2) == 0) // 50% chance
            {
                urlPath += $"?query={rand.Next(1, 10)}";
            }

            // Generating a random HTTP status code
            int statusCode = rand.Next(200, 600);

            // Generating a fake response size
            int responseSize = rand.Next(100, 10001); // size in bytes

            // Generating a fake user agent
            string userAgent = GenerateUserAgent(rand);

            int timeTaken = rand.Next(40, 300);

            // Combining all parts into a single log entry
            return $"{dateTime} {clientIP} {method} {urlPath} {statusCode} {responseSize} {timeTaken} \"{userAgent}\"";
        }

        private static string GenerateUrlPath(DateTime currentDateTime)
        {
            // Example of defining more visited pages based on time of day
            var peakHours = new List<int> { 7, 8, 9, 17, 18, 19 }; // Morning and evening peaks
            var popularPagesDuringPeak = new List<string> { "/home", "/news/latest", "/products/new-arrivals" };
            var otherPages = new List<string> { "/about-us", "/contact", "/products/list", "/blog" };

            bool isPeakHour = peakHours.Contains(currentDateTime.Hour);

            // 75% chance to visit popular pages during peak hours, 25% otherwise
            if (isPeakHour && rand.Next(0, 100) < 75)
            {
                return popularPagesDuringPeak[rand.Next(popularPagesDuringPeak.Count)];
            }
            else
            {
                return otherPages.Union(popularPagesDuringPeak).ToList()[rand.Next(otherPages.Count + popularPagesDuringPeak.Count)];
            }
        }

        private static string GenerateUserAgent(Random rand)
        {
            string[] userAgents = {
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15",
        "Mozilla/5.0 (iPad; CPU OS 13_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Mobile/15E148 Safari/604.1",
        "Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Mobile Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0",

        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36",
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0",
        "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)",
        "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
        "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)",
        "DuckDuckBot/1.0; (+http://duckduckgo.com/duckduckbot.html)",
        "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)",
        "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)",
        "Mozilla/5.0 (Platform; Encryption; OS_or_Device; Language) AppleWebKit/AppleWebKitVersion (KHTML, like Gecko) Version/SafariVersion Safari/AppleWebKit"
            };
            return userAgents[rand.Next(userAgents.Length)];
        }
    }
}
