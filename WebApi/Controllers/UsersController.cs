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
            _repository = EFRepository.Instance;
            
        }

        [Route("check")]
        [Authorize]
        public IHttpActionResult GetUserInfo()
        {
            var user = User;
            return Ok(user.Identity.GetUserId());
        }

        [Route("")]
        public List<UserBasicInfoViewModel> Get()
        {
            return _repository.GetUsers().Select(x=>new UserBasicInfoViewModel(x)).ToList();   
        }

        [Route("login")]
        [HttpPost]
        public IHttpActionResult Login([FromBody]UserLoginViewModel user)
        {  
            try
            {
                var userResult = _repository.Login(user.Username,user.Password);
                return Ok(new UserBasicInfoViewModel(userResult));
            }
            catch(Exception)
            {
                return Unauthorized();
            }
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

        [Route("Check")]
        public IHttpActionResult Token()
        {
            return Ok();
        }



        
    }
}
