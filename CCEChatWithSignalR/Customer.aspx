<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Customer.aspx.cs" Inherits="CCEChatWithSignalR.Customer" %>
<%@ Import Namespace="CCEChatWithSignalR" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Agent Page</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="Login">
        enter user name : <asp:TextBox ID="username" placeholder="User Name" runat="server"/>
        <input type="submit" value="Login" id="btnLogin"/>
    </div>
    <div id="chat" style="display: none">
        <input type="button" id="StartChat" value="Connect To Agent"/>
        <div id="innerChat">            
            <input type="text" id="msg" value="" placeholder="Chat Message" />
            <input type="button" id="send" value="send" />
            <input type="text" value="" id="AgentId"/>
            <ul id="message">
            </ul>   
        </div>
    </div>   
</asp:Content>
<asp:Content ID="Scripts" ContentPlaceHolderID="FooterScripts" runat="server">
    <script>
        $(document).ready(function () {
            var chat = $.connection.chatHub;

            chat.client.SendMsg1 = function (msg) {
                $('#message').append('<li>' + msg + '</li>');
            };

            chat.client.ConnectedToAgent = function(agentId) {
                if (agentId.trim() == "") {
                    alert('Please try after sometime.  No Agent Available right now.');
                    $.connection.hub.stop(true);
                    return;
                }
                $("#innerChat input").attr("disabled", false);
                $("#StartChat").fadeOut();
                $('#AgentId').val(agentId);
                chat.server.askAgentToJoin(agentId);
                $('#send').click(function() {
                    chat.server.sendPersonalMsg($('#AgentId').val(), $('#msg').val()).done(function () {
                        $('#msg').val('');
                    });
                });
            };

            if ('<%=isLoggedIn %>'.toUpperCase() == 'TRUE') {                                                
                
                $('#Login').fadeOut();
                $('#chat').fadeIn();
                $("#innerChat input").attr("disabled", true);
                $("#StartChat").click(function () {
                    $.connection.hub.qs = "name=<%=username.Text%>";
                    $.connection.hub.start().done(function () {
                        chat.server.registerMeAsCustomer();                        
                    });
                });
            }
                        
        });                
    </script>
</asp:Content> 