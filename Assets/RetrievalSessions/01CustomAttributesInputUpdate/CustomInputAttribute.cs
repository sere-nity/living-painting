using System;
using System.Collections;
using System.Collections.Generic;
using PixelCrushers.DialogueSystem.Articy;
using UnityEngine;

namespace CustomAttributes
{

    // note that inherited methods will also have the attribute applied ... inherited methods?? I don't think that's possible
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
    public class CustomInputAttribute : Attribute
    {

        private int? _priority;
        
        public int priority
        {
            get
            {
                return _priority.GetValueOrDefault();
            }

            set
            {
                _priority = value; 
            }
        }

    }
    
}

