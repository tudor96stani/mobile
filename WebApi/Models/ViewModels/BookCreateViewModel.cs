using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class BookCreateViewModel
    {
        public string Title { get; set; }
        public Guid AuthorId { get; set; }
        public Guid UserId { get; set; }
    }
}