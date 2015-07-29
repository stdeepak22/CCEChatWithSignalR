using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace CCEChatWithSignalR
{
    public class ChatHub : Hub
    {
        static List<string> Agent = new List<string>();
        static Dictionary<string,string> dicNames = new Dictionary<string, string>(); 
        static List<string> Customer = new List<string>();         

        public void Hello()
        {
            Clients.All.hello();
        }

        public void SendMsg(string message)
        {
            Clients.All.SendMsg1(message + "-" + (Agent.Any(c=>c==Context.ConnectionId)?"Agent":"Customer"));            
        }

        public void RegisterMeAsAgent()
        {            
            Groups.Add(Context.ConnectionId, "Agent");
            Agent.Add(Context.ConnectionId);            
        }

        public void RegisterMeAsCustomer()
        {
            Groups.Add(Context.ConnectionId, "Customer");
            Customer.Add(Context.ConnectionId);
            string firstAgent = string.Empty;
            if (Agent.Any())
            {
                firstAgent = Agent.First();
                Agent.RemoveAt(0);
                Agent.Add(firstAgent);
                //Clients.Client(firstAgent).CustomerWantToConnect("User Name", Context.ConnectionId);
            }
            Clients.Client(Context.ConnectionId).ConnectedToAgent(firstAgent);
            //Clients.Caller.ConnectedToAgent(firstAgent);
        }

        public void AskAgentToJoin(string AgentId)
        {
            Clients.Client(AgentId).CustomerWantToConnect(dicNames[Context.ConnectionId], Context.ConnectionId);
        }

        public void SendPersonalMsg(string connectionId, string msg)
        {
            msg = dicNames[Context.ConnectionId] + ":" + msg;
            Clients.Client(connectionId).SendMsg1(msg);
            //Clients.User(dicNames[connectionId]).SendMsg1(msg);
            Clients.Caller.SendMsg1(msg);
        }

        public override System.Threading.Tasks.Task OnConnected()
        {
            var result = base.OnConnected();
            Clients.Client(Context.ConnectionId).SendMsg1("My ID is - " + Context.ConnectionId);
            dicNames.Add(Context.ConnectionId, Context.User.Identity.Name);
            return result;
        }

        public override System.Threading.Tasks.Task OnDisconnected(bool stopCalled)
        {
            Agent.Remove(Context.ConnectionId);
            Customer.Remove(Context.ConnectionId);
            dicNames.Remove(Context.ConnectionId);
            return base.OnDisconnected(stopCalled);
        }
    }
}