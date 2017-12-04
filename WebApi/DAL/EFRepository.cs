﻿using System;
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
                if (db_book == null)
                    return null;
                db_book.Title = book.Title;
                db_book.AuthorId = book.AuthorId;
                dbCtx.SaveChanges();
                return dbCtx.Books.Include(x => x.Author).FirstOrDefault(x => x.Id == book.Id);
            }
        }

        public List<Author> GetAuthors()
        {
            using(var dbCtx = new ApplicationDbContext())
            {
                return dbCtx.Authors.ToList();
            }
        }

        public Book Create(string title, Guid authorid,Guid userid)
        {
            using (var db = new ApplicationDbContext())
            {
                if (db.Books.Any(x => x.Title == title && x.AuthorId == authorid))
                    throw new Exception("Book already exists!");
                var author = db.Authors.FirstOrDefault(x => x.Id == authorid);
                if (author == null)
                    throw new Exception("Author not valid!");

                var user = db.Users.FirstOrDefault(x => x.Id == userid);
                if (user == null)
                    throw new Exception("User not valid!");
                var book = new Book()
                {
                    Id = Guid.NewGuid(),
                    Title = title,
                    AuthorId = author.Id,
                    Author=author,
                    
                };
                book.Users.Add(user);
                var addResult = db.Books.Add(book);
                if (addResult == null)
                    throw new Exception("Could not create book!");
                user.Books.Add(addResult);
                db.SaveChanges();
                return addResult;
            }
        }

        public bool Delete(Guid Id)
        {
            using (var db = new ApplicationDbContext())
            {
                var book = db.Books.Include(x => x.Author).Include(x => x.Users).FirstOrDefault(x => x.Id == Id);
                if (book == null)
                    return false;
                db.Books.Remove(book);
                db.SaveChanges();
                return true;
            }
        }
    }
}
