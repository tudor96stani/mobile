using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using WebApi.DAL;

namespace WebApi.Security
{
    public class SimpleAuthorizationServerProvider: OAuthAuthorizationServerProvider
    {
        private readonly EFRepository _repo = new EFRepository();
        public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { "*" });
            var user = _repo.Login(context.UserName, context.Password);
            if (user == null)
            {
                context.SetError("invalid_grant", "The user name or password is incorrect.");
                return;
            }
            /*
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim("Username", context.UserName));
            identity.AddClaim(new Claim("Id", user.Id.ToString()));
            identity.AddClaim(new Claim("Role", user.Role.ToString()));
            var props = new AuthenticationProperties(new Dictionary<string, string>
                {
                    {
                        "Username", context.UserName
                    },
                    {
                        "Id", user.Id.ToString()
                    },
                    {
                    "Role", user.Role.ToString()
                    }
                });
            var ticket = new AuthenticationTicket(identity, props);
            
            context.Validated(ticket);*/
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim("Username", context.UserName));
            identity.AddClaim(new Claim("Id", user.Id.ToString()));
            identity.AddClaim(new Claim("Role", user.Role.ToString()));
            List<Claim> roles = identity.Claims.Where(c => c.Type == ClaimTypes.Role).ToList();
            AuthenticationProperties properties = CreateProperties(user.Username,user.Id.ToString(),user.Role);

            AuthenticationTicket ticket = new AuthenticationTicket(identity, properties);
            context.Validated(ticket);
            //context.Request.Context.Authentication.SignIn(cookiesIdentity);
        }

        public static AuthenticationProperties CreateProperties(string userName, string id,int role)
        {
            IDictionary<string, string> data = new Dictionary<string, string>
        {
            { "Username", userName },
            {"Role",role.ToString()},
                {"Id",id }
        };
            return new AuthenticationProperties(data);
        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }
    }


}