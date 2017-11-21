using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public abstract class ResponseViewModel
    {
        public string Message { get; set; }
        public bool Ok { get; set; }
    }
}