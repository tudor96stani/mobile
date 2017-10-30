using System;
using System.Collections.Generic;
using WebApi.Models;

namespace WebApi.DAL
{
    public class MockRepository//:IRepository
    {
        private static MockRepository _instance;
        private List<User> _users;
        private MockRepository()
        {
            _users = new List<User>()
            {new User(){Username="username1",PasswordHash="Password1.",Role=1},
                                   new User() { Username = "username2", PasswordHash = "Password1.", Role = 1 },
                                    new User() { Username = "username3", PasswordHash = "Password1.", Role = 2 },
                                    new User() { Username = "username4", PasswordHash = "Password1.", Role = 2 }
                };
        }
        public static MockRepository Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new MockRepository();
                return _instance;
            }
        }

        public List<User> GetUsers()
        {
            return _users;
        }

        public User Login(string username, string password)
        {
            throw new NotImplementedException();
        }
    }
}
