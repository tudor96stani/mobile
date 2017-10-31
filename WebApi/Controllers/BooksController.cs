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
    [Authorize]
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
            var books = _repository.GetBooksForUser(userId);
            return books.Select(x=>new BookViewModel(x)).ToList();
        }

        [Route("{id:Guid}")]
        public BookViewModel GetBook(Guid id)
        {
            var book = _repository.GetBookById(id);
            if (book != null)
                return new BookViewModel(book);
            else
                return null;
        }

        [HttpPost]
        [Route("update")]
        [Authorize(Roles ="owner")]
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
