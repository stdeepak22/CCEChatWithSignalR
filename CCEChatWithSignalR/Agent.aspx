<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Agent.aspx.cs" Inherits="CCEChatWithSignalR.Agent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Agent Page</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="Login">
        enter user name : <asp:TextBox ID="username" placeholder="User Name" runat="server"></asp:TextBox>        
        <input type="submit" value="Login" id="btnLogin"/>
    </div>
    <div id="chat" style="display: none">
        <input type="button" id="StartChat" value="Connect To Customer"/>
        <div id="innerChat">
            <%=User.Identity.Name %>
            <input type="text" id="msg" value="" placeholder="Chat Message" />
            <input type="button" id="send" value="send" />
            <input type="text" value="" id="CustomerId"/>
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

            var customerId;
            chat.client.CustomerWantToConnect = function (CustomerName, CustomerId) {
                customerId = CustomerId;
                $('#StartChat').val(CustomerName + ' want to chat, click the button to start');
                $('#StartChat').removeAttr("disabled");
            };
            


            if ('<%=isLoggedIn %>'.toUpperCase() == 'TRUE') {
                $.connection.hub.qs = "name=<%=username.Text%>";
                $.connection.hub.start().done(function () {
                    chat.server.registerMeAsAgent();
                    $('#Login').fadeOut();
                    $('#chat').fadeIn();
                    $("#chat input").attr("disabled", true);
                    $('#StartChat').click(function () {
                        $('#StartChat').attr("disabled", true);
                        $('#innerChat input').removeAttr("disabled", false);
                        $('#CustomerId').val(customerId);
                        $('#send').click(function() {
                            chat.server.sendPersonalMsg($('#CustomerId').val(), $('#msg').val()).done(function() {
                                $('#msg').val('');
                            });
                        });
                    });
                });
            }
        });                
    </script>
</asp:Content> 