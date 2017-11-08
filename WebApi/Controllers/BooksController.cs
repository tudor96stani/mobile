using NLog;
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
        private static Logger Logger = LogManager.GetCurrentClassLogger();
        public BooksController()
        {
            _repository = new EFRepository();
        }

        //GET /api/v1/books/{guid}
        [Route("user/{userId:Guid}")]
        public IEnumerable<BookViewModel> Get(Guid userId)
        {
            Logger.Trace("BooksController/Get Entered method, userId={0}", userId);
            var books = _repository.GetBooksForUser(userId);
            Logger.Trace("BooksController/Get Found {0} books for userId={1}", books.Count, userId);
            return books.Select(x=>new BookViewModel(x)).ToList();
        }

        [Route("{id:Guid}")]
        public BookViewModel GetBook(Guid id)
        {
            var book = _repository.GetBookById(id);
            if (book != null)
                return new BookViewModel(book);
            else
            {
                Logger.Warn("BooksController/GetBook DB returned null for bookId={0}", id);
                return null;
            }
        }

        [HttpPost]
        [Route("update")]
        [Authorize(Roles ="owner")]
        public BookViewModel UpdateBook([FromBody] BookUpdateViewModel book)
        {
            Logger.Trace("BooksController/UpdateBook bookId={0},title={1},authorId={2}",book.Id.ToString(), book.Title, book.AuthorId.ToString());
            var BookObj = new Book()
            {
                Id = book.Id,
                Title = book.Title,
                AuthorId = book.AuthorId
            };
            var updatedBook = _repository.UpdateBook(BookObj);
            BookViewModel result = null;
            if (updatedBook != null)
            {
                result = new BookViewModel(updatedBook);
                return result;
            }
            else
            {
                Logger.Warn("BooksController/UpdateBook DB returned null for bookId={0}", book.Id);
                return null;
            }
            
        }
    }
}
