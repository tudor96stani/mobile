using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class SuccessFailureViewModel
    {
        public bool Ok { get; set; }
        public string Message { get; set; }
    }
}