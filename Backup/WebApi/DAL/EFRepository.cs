using System;
using System.Collections.Generic;
using System.Linq;
using WebApi.Models;
using System.Data.Entity;
namespace WebApi.DAL
{
    public class EFRepository: IRepository
    {
        private static EFRepository _instance;

        private EFRepository()
        {
        }

        public static EFRepository Instance
        {
            get
            {
                if (_instance == null)
                    _instance = new EFRepository();
                return _instance;
            }
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
                if (!user.PasswordHash.Equals(password))
                    throw new Exception();

                return user;
                    
            }
        }

        public List<Book> GetBooksForUser(Guid userId)
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Users.Include(x => x.Books).FirstOrDefault(x => x.Id == userId).Books.ToList();
            }
        }
    }
}
