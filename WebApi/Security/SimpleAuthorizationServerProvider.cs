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
            // validate client credentials (demo)
            // should be stored securely (salted, hashed, iterated)
            /*
            string id, secret;
            if (context.TryGetBasicCredentials(out id, out secret))
            {
                if (secret == "secret")
                {
                    // need to make the client_id available for later security checks
                    context.OwinContext.Set<string>("as:client_id", id);
                    context.Validated();
                }
            }*/
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
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            string role = user.Role == 1 ? "viewer" : "owner";
            identity.AddClaim(new Claim(ClaimTypes.Role, role));
            AuthenticationProperties properties = CreateProperties(user.Username,user.Id.ToString(),user.Role,context.ClientId);
            AuthenticationTicket ticket = new AuthenticationTicket(identity, properties);
            context.Validated(ticket);
        }

        /*
        public override async Task GrantRefreshToken(OAuthGrantRefreshTokenContext context)
        {
            var originalClient = context.Ticket.Properties.Dictionary["as:client_id"];
            var currentClient = context.OwinContext.Get<string>("as:client_id");

            // enforce client binding of refresh token
            if (originalClient != currentClient)
            {
                context.Rejected();
                return;
            }

            // chance to change authentication ticket for refresh token requests
            var newId = new ClaimsIdentity(context.Ticket.Identity);
            newId.AddClaim(new Claim("newClaim", "refreshToken"));

            var newTicket = new AuthenticationTicket(newId, context.Ticket.Properties);
            context.Validated(newTicket);
        }
        */


        public static AuthenticationProperties CreateProperties(string userName, string id,int role,string clientid)
        {
            IDictionary<string, string> data = new Dictionary<string, string>
            {
                { "Username", userName },
                { "Role", role.ToString()},
                { "Id", id }
                //{ "as:client_id", clientid }
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