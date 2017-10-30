using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Web.Http;
using WebApi.DAL;
using WebApi.Models;

namespace WebApi.Controllers
{
    [RoutePrefix("api/v1/books")]
    public class BooksController: ApiController
    {
        private IRepository _repository;
        public BooksController()
        {
            _repository = EFRepository.Instance;
        }

        //GET /api/v1/books/{guid}
        [Route("{userId:Guid}")]
        public IEnumerable<Book> Get(Guid userId)
        {
            return _repository.GetBooksForUser(userId);
        }
    }
}
