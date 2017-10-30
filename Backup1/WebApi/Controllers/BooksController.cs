using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using WebApi.DAL;
using WebApi.Models;
using WebApi.Models.ViewModels;

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
        public IEnumerable<BookViewModel> Get(Guid userId)
        {
            return _repository.GetBooksForUser(userId).Select(x=>new BookViewModel(x)).ToList();
        }
    }
}
