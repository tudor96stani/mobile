using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class BookViewModel
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public AuthorViewModel Author { get; set; }

        public BookViewModel(Book book)
        {
            Id = book.Id;
            Title = book.Title;
            Author = new AuthorViewModel(book.Author);
        }
    }
}