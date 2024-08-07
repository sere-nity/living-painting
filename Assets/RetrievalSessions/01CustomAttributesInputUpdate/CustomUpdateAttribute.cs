/*
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CustomAttributes
{
    /// <summary>
    /// Should be used to annotate methods that need periodic execution
    /// Two methods should not have two different update attributes. 
    /// </summary>
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public class CustomUpdateAttribute : Attribute
    {
        // what properties are needed? 
        // I need an update type enum but where should I store it? 
        // I'll do it here for now until the game demands I need to have it elsewhere
        public enum UpdateType
        {
            NORMAL,
            FIXED,
            LATE 
        }
        
        // COMPULSORY ATTRIBUTES - must be set in the constructor 
        public UpdateType Type { get; private set; }
        
        // OPTIONAL ATTRIBUTES
        
        /// other properties include an ignore time scale bool i.e. this method 
        /// should keep running even if the game is paused
        /// the default value is false 
        public bool IgnoreTimeScale { get; set; } = false;
        
        // Other properties can be added like priority 
        public int Priority { get; set; } = 0; 
        public CustomUpdateAttribute(UpdateType type)
        {
            Type = type;
        } 
    }   
}
*/

