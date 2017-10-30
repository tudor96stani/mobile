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
            _repository = new EFRepository();
        }

        //GET /api/v1/books/{guid}
        [Route("user/{userId:Guid}")]
        public IEnumerable<BookViewModel> Get(Guid userId)
        {
            return _repository.GetBooksForUser(userId).Select(x=>new BookViewModel(x)).ToList();
        }

        [Route("{id:Guid}")]
        public BookViewModel GetBook(Guid id)
        {
            return new BookViewModel(_repository.GetBookById(id));
        }

        [HttpPost]
        [Route("update")]
        public BookViewModel UpdateBook([FromBody] BookUpdateViewModel book)
        {
            var BookObj = new Book()
            {
                Id = book.Id,
                Title = book.Title,
                AuthorId = book.AuthorId
            };
            var updatedBook = _repository.UpdateBook(BookObj);
            BookViewModel result = null;
            if (updatedBook != null)
                result = new BookViewModel(updatedBook);
            return result;
        }
    }
}
