using Microsoft.AspNet.Identity;
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

        [HttpPost]
        [Route("create")]
        [Authorize(Roles = "owner")]
        public BookCreateReponseViewModel Create([FromBody] BookCreateViewModel model)
        {
            if(ModelState.IsValid)
            {
                Logger.Trace($"BooksController/Create Entered Create, title={0},authorid={1}", model.Title, model.AuthorId.ToString());
                try
                {
                    
                    var createdBook = _repository.Create(model.Title,model.AuthorId,model.UserId);

                    return new BookCreateReponseViewModel()
                    {
                        Ok = true,
                        Message = "Success",
                        Book = new BookViewModel(createdBook)
                    };
                }
                catch (Exception ex)
                {
                    Logger.Error($"BooksController/Create Exception thrown while creating: {0}", ex.Message);
                    return new BookCreateReponseViewModel()
                    {
                        Ok = false,
                        Message = ex.Message,
                        Book = null
                    };
                }
                
                
            }
            else
            {
                Logger.Warn($"BooksController/Create Model not valid for title={0},authorid={1}", model.Title, model.AuthorId);
                return new BookCreateReponseViewModel()
                {
                    Ok = false,
                    Message = "Invalid data was sent!",
                    Book = null
                };
            }
        }


        [HttpPost]
        [Route("delete/{id:Guid}")]
        [Authorize(Roles = "owner")]
        public SuccessFailureViewModel Delete(Guid id)
        {
            if (_repository.Delete(id))
                return new SuccessFailureViewModel() { Ok = true, Message = "Success" };
            return new SuccessFailureViewModel() { Ok = false, Message = "There was an error deleting the book!" };
        }
    }
}
