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
    [RoutePrefix("api/v1/users")]
    public class UsersController: ApiController
    {
        private IRepository _repository;
        public UsersController()
        {
            _repository = EFRepository.Instance;
        }

        [Route("")]
        public List<UserBasicInfoViewModel> Get()
        {
            return _repository.GetUsers().Select(x=>new UserBasicInfoViewModel(x)).ToList();   
        }

        [Route("")]
        [HttpPost]
        public IHttpActionResult Get([FromBody]UserLoginViewModel user)
        {
            try
            {
                var userResult = _repository.Login(user.Username,user.Password.GetHashCode().ToString());
                return Ok(new UserBasicInfoViewModel(userResult));
            }
            catch(Exception)
            {
                return Unauthorized();
            }
        }
    }
}
