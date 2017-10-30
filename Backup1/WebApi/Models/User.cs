using System;
using System.Collections.Generic;
namespace WebApi.Models
{
    public class User
    {
        public Guid Id { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public int Role { get; set; }
        public virtual ICollection<Book> Books { get; set; }
        public User()
        {
            Books = new HashSet<Book>();
        }
    }
}
