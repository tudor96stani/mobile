using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using WebApi.Security;

[assembly: OwinStartup(typeof(WebApi.App_Start.Startup))]
namespace WebApi.App_Start
{
    
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            
            HttpConfiguration config = new HttpConfiguration();
            WebApiConfig.Register(config);
            app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
            ConfigureOAuth(app);
            app.UseWebApi(config);
        }

        public void ConfigureOAuth(IAppBuilder app)
        {
            OAuthAuthorizationServerOptions OAuthServerOptions = new OAuthAuthorizationServerOptions()
            {
                AllowInsecureHttp = true,
                TokenEndpointPath=new PathString("/token"),
                AccessTokenExpireTimeSpan=TimeSpan.FromMinutes(60),
                Provider= new SimpleAuthorizationServerProvider()
                //RefreshTokenProvider = new SimpleRefreshTokenProvider()
            };
            app.UseOAuthAuthorizationServer(OAuthServerOptions);
            app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions());
        }
    }
}