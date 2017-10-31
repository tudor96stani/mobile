using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using WebApi.DAL;
using WebApi.Models;
using WebApi.Models.ViewModels;
using WebApi.Security;

namespace WebApi.Controllers
{
    [RoutePrefix("api/v1/users")]
    public class UsersController: ApiController
    {
        private IRepository _repository;
      
        public UsersController()
        {
            _repository = new EFRepository();
            
        }

        [Authorize]
        [Route("verify")]
        [HttpGet]
        public IHttpActionResult Check()
        {
            return Ok();
        }

        [Route("register")]
        [HttpPost]
        public RegisterReponseViewModel Register([FromBody]UserRegisterViewModel user)
        {
            try
            {
                var userResult = _repository.Register(user.Username, user.Password, user.Role);
                var result = new RegisterReponseViewModel()
                {
                    Ok = true,
                    Message = "OK",
                    User = new UserBasicInfoViewModel() { Id=userResult.Id,Username=userResult.Username,Role=userResult.Role}
                };
                return result;
            }catch(Exception ex)
            {
                var result = new RegisterReponseViewModel()
                {
                    Ok = false,
                    Message = ex.Message,
                    User = null
                };
                return result;
            }
        }
    }
}
