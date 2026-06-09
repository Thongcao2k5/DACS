using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IAiChatService
    {
        Task<string> GetReplyAsync(string userMessage, string conversationHistory);
    }
}
