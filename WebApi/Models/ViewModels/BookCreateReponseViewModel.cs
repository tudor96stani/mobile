﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApi.Models.ViewModels
{
    public class BookCreateReponseViewModel: ResponseViewModel
    {
        public BookViewModel Book { get; set; }
        
    }
}