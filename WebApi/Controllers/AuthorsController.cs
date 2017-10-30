using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebApi.DAL;
using WebApi.Models.ViewModels;

namespace WebApi.Controllers
{
    [RoutePrefix("api/v1/authors")]
    public class AuthorsController : ApiController
    {

        private readonly IRepository _repository;
        public AuthorsController()
        {
            _repository = new EFRepository();
        }

        [Route("")]
        public IEnumerable<AuthorViewModel> Get()
        {
            return _repository.GetAuthors().Select(x => new AuthorViewModel(x)).ToList();
        }
    }
}
