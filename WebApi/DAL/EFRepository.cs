using System;
using System.Collections.Generic;
using System.Linq;
using WebApi.Models;
using System.Data.Entity;
using WebApi.Security;

namespace WebApi.DAL
{
    public class EFRepository: IRepository
    {

        public EFRepository()
        {
        }


        public List<User> GetUsers()
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Users.ToList();    
            }
        }

        public User Login(string username, string password)
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                
                var user = dbCtx.Users.FirstOrDefault(x => x.Username.Equals(username));
                if (user == null)
                    throw new Exception();
                if (!SecurePasswordHasher.Verify(password, user.PasswordHash))
                    throw new Exception();

                return user;
                    
            }
        }

        public List<Book> GetBooksForUser(Guid userId)
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Users.Include(x => x.Books.Select(y=>y.Author)).FirstOrDefault(x => x.Id == userId).Books.ToList();
            }
        }

        public User Register(string username, string password, int role)
        {
            using (var dbCtx = new ApplicationDbContext())
            {
                if (dbCtx.Users.Any(x => x.Username.Equals(username)))
                    throw new Exception("Username taken!");
                var user = new User() { Username = username, Role = role, PasswordHash = SecurePasswordHasher.Hash(password),Id=Guid.NewGuid() };
                dbCtx.Users.Add(user);
                dbCtx.SaveChanges();
                return user;
            }
        }

        public Book GetBookById(Guid bookId)
        {
            using (var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Books.Include(x => x.Author).FirstOrDefault(x => x.Id == bookId);
            }
        }

        public Book UpdateBook(Book book)
        {
            using (var dbCtx = new ApplicationDbContext())
            {
                var db_book = dbCtx.Books.Include(x => x.Author).FirstOrDefault(x => x.Id == book.Id);
                db_book.Title = book.Title;
                db_book.AuthorId = book.AuthorId;
                dbCtx.SaveChanges();
                return db_book;
            }
        }

        public List<Author> GetAuthors()
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Authors.ToList();
            }
        }
    }
}
