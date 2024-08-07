/*using System;
using UnityEngine;
using UnityEngine.Animations;

namespace CustomAttributes
{
    public abstract class Agent : IDisposable
    {
        // constructor - the behaviour component in which 
        // the member with the attribute monitored by the agent is attached to is passed in 
        public Agent(Behaviour parent)
        {
            this.parent = parent;
        }

        protected Behaviour parent;

        private bool _isFinished;

        public bool isFinished
        {
            get
            {
                // check if it's not finished yet and also an EXISTENCE CHECK of the parent 
                if (!isFinished && !parent)
                {
                    Dispose();
                    
                }

                return _isFinished;
            }
        }
        
        
        public virtual void Dispose()
        {
            // initially I was checking whether the parent was active in this class but that functionality 
            // is implemented in its derived classes 

            _isFinished = true; 

        }
    }
}*/