using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.ClientServices;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCEChatWithSignalR
{
    public partial class Customer : System.Web.UI.Page
    {
        public bool isLoggedIn = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(username.Text))
            {
                FormsAuthentication.SetAuthCookie(username.Text, true);
                isLoggedIn = true;
            }
        }
    }
}