using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class UserRegisterViewModel
    {
     
        public string Username { get; set; }
        public string Password { get; set; }
        public int Role { get; set; }
    }
}