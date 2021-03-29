using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using MotFunction.Models;
using Newtonsoft.Json;

namespace MotFunction
{
    public static class SetMotReminder
    {
        [FunctionName("SetMotReminder")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "PUT", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var data = JsonConvert.DeserializeObject<ReminderRequest>(requestBody);

            var responseMessage = data == null ? "Invalid request format" : $"VIN: {data.VIN}, email:{data.Email}";

            return new OkObjectResult(responseMessage);
        }
    }
}

