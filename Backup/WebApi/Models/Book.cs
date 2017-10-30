using System;
using System.Collections.Generic;
namespace WebApi.Models
{
    public class Book
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public Guid AuthorId { get; set; }
        public virtual Author Author { get; set; }
        public virtual ICollection<User> Users { get; set; }
        public Book()
        {
            Users = new HashSet<User>();
        }
    }
}
