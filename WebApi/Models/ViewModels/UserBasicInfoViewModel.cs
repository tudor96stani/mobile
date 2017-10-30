using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class UserBasicInfoViewModel
    {
        public Guid Id { get; set; }
        public string Username { get; set; }
        public int Role { get; set; }

        public UserBasicInfoViewModel(User user)
        {
            Id = user.Id;
            Username = user.Username;
            Role = user.Role;
        }

        public UserBasicInfoViewModel()
        {
        }
    }
}