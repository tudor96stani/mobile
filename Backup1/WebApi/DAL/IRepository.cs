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
        #endregion

        #region Books

        List<Book> GetBooksForUser(Guid userId);
        #endregion
    }
}
