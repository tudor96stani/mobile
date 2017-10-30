using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Web.Http;
using WebApi.DAL;
using WebApi.Models;

namespace WebApi.Controllers
{
    [RoutePrefix("api/v1/users")]
    public class UsersController: ApiController
    {
        private IRepository _repository;
        public UsersController()
        {
            _repository = EFRepository.Instance;
        }

        [Route("")]
        public List<User> Get()
        {
            return _repository.GetUsers();   
        }

        [Route("")]
        [HttpPost]
        public IHttpActionResult Get([FromBody]User user)
        {
            try
            {
                var userResult = _repository.Login(user.Username,user.PasswordHash);
                return Ok(userResult);
            }
            catch(Exception)
            {
                return Unauthorized();
            }
        }
    }
}
