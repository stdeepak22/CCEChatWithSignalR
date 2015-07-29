<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Agent.aspx.cs" Inherits="CCEChatWithSignalR.UsingUserName.Agent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Agent Page</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="form1" runat="server" class="form-horizontal">               
        <div id="Login" class="col-sm-6 col-sm-offset-3">
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="glyphicon glyphicon-user"></i>
                    </span>
                    <asp:TextBox ID="username" placeholder="User Name" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox> 
                </div>
            </div>
            <div class="form-group">
                <asp:HiddenField runat="server" ID="connectionID"/>       
                <input type="submit" value="Login" id="btnLogin" class="btn btn-primary"/>
            </div>           
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
    </form>   
</asp:Content>
<asp:Content ID="Scripts" ContentPlaceHolderID="FooterScripts" runat="server">
    <script>
        $(document).ready(function () {
            var chat = $.connection.chatHubUsingUserName;

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