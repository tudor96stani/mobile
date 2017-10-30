using System;
using System.Collections.Generic;

namespace WebApi.Models
{
    public class Author
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public virtual ICollection<Book> Books { get; set; }

        public Author() => Books = new HashSet<Book>();
    }
}
