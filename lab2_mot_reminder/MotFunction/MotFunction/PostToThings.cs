using System;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos.Table;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace MotFunction
{
    public static class PostToThings
    {
        [FunctionName("PostToQueue")]
        public static async Task<IActionResult> PostToQueue(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            [Queue("mailreminder"), StorageAccount("EXTERNAL_STORAGE_ACCOUNT_CONNECTION")] ICollector<string> queue,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var name = await ReadNameFromRequest(req);

            if (string.IsNullOrEmpty(name))
            {
                return new BadRequestErrorMessageResult("Pass a name in the query string or in the request body");
            }

            var responseMessage = $"Hello, {name}. This HTTP triggered function executed successfully.";

            try
            {
                log.LogInformation("Adding message to the queue.");
                queue.Add(responseMessage);
            }
            catch (System.Exception ex)
            {
                log.LogError(ex.Message);
                log.LogError(ex.StackTrace);
                return new InternalServerErrorResult();
            }

            return new OkObjectResult(responseMessage);
        }

        [FunctionName("PostToTable")]
        public static async Task<IActionResult> PostToTable(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            [Table("reminders", Connection = "EXTERNAL_STORAGE_ACCOUNT_CONNECTION")] CloudTable table,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            var name = await ReadNameFromRequest(req);

            if (string.IsNullOrEmpty(name))
            {
                return new BadRequestErrorMessageResult("Pass a name in the query string or in the request body");
            }

            try
            {
                log.LogInformation("Searching the table.");

                await table.CreateIfNotExistsAsync();

                var query = await table.ExecuteQuerySegmentedAsync<Thing>(new TableQuery<Thing>().Where(
                    TableQuery.CombineFilters(
                        TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, "FixedPartition"),
                        TableOperators.And,
                        TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.Equal, name)
                    )
                ), null);

                if (query.Results.Count > 0)
                {
                    log.LogInformation("Thing already exists");
                    return new OkObjectResult($"The thing {query.Results[0].Name} is alreay in the table, birthdate is {query.Results[0].BirthDate:u}");
                }
                else
                {
                    log.LogInformation("Inserting thing in table");
                    var thing = new Thing() { Name = name, BirthDate = DateTime.UtcNow };
                    var insertResult = table.ExecuteAsync(TableOperation.Insert(thing));
                    return new OkObjectResult($"Hello, {name}. Your data was recorded succesfully.");
                }
            }
            catch (System.Exception ex)
            {
                log.LogError(ex.Message);
                log.LogError(ex.StackTrace);
                return new InternalServerErrorResult();
            }
        }

        private static async Task<string> ReadNameFromRequest(HttpRequest req)
        {
            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name ??= data?.name;

            return name;
        }

        private class Thing : TableEntity
        {
            private string name;

            public Thing()
            {
                this.PartitionKey = "FixedPartition";
                this.Timestamp = DateTime.UtcNow;
            }

            public string Name
            {
                get { return name; }
                set
                {
                    RowKey = value;
                    name = value;
                }
            }
            public DateTime BirthDate { get; set; }
        }
    }
}
