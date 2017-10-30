using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Data.Entity;
using WebApi.Models;

namespace WebApi.DAL
{
    public class ApplicationDbContext: DbContext
    {
        public ApplicationDbContext():base("Mobile")
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Author> Authors { get; set; }
        public DbSet<Book> Books { get; set; }

        
    }
}
