using System;
using System.Collections.Generic;
using WebApi.Models;
namespace WebApi.DAL
{
    public interface IRepository
    {
        #region Users
        List<User> GetUsers();
        User Login(string username, string password);
        User Register(string username, string password, int role);
        #endregion

        #region Books

        List<Book> GetBooksForUser(Guid userId);
        Book GetBookById(Guid bookId);
        Book UpdateBook(Book book);
        Book Create(string title, Guid authorid,Guid userid);
        bool Delete(Guid Id);
        #endregion

        #region Authors
        List<Author> GetAuthors();
        #endregion
    }
}
