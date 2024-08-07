/*
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using CustomAttributes;
using UnityEngine;

/// <summary>
/// Develop a CustomInputManager script that scans objects for methods annotated with
/// CustomInputAttribute. This manager should listen for specified key inputs and invoke the annotated methods when their respective keys are pressed.
/// </summary>
public class CustomInputManager : MonoBehaviour
{
    // I now realise the importance of agents because there's no way this class
    // can know about all the other classes which use the CustomInputAttribute without an Agent
    
    // THIS IS JUST GENERAL REFLECTION CODE - IT'S NOT SCALABLE AT ALL 
    // IT ASSUMES THE METHOD YOU ATTACH THE INPUT ATTRIBUTE TO IS IN THIS CLASS 
    
    // TODO: Perform reflection once during awake - this is a possible modification (think about a dictionary like in DE) 
    private void Awake()
    {
        
    }
    
    public class EventData
    {
        // what common functionality in EventData? 
        // just a used property

        private bool _used;

        public EventData()
        {
            _used = false; 
        }

    }

    public class AxisEventData : EventData
    {
        
    }

    public abstract class TriggerEventData : EventData
    {
        
    }

    public class ButtonEventData : TriggerEventData
    {
        
    }

    public class KeyCodeEventData : TriggerEventData
    {
        
    }

    
    // this is the base class from which all the different input agents are derived from 
    public abstract class EventHandlerAgent : Agent
    {
        // what common functionality does it need? 
        
        // so we have a property to check whether the parent is active along with the parent null existence
        // check from its parents (as all derived classes need this check) 

        public bool isActive
        {
            get
            {
                if (!base.isFinished)
                {
                    return parent.isActiveAndEnabled;
                }

                return false; 
            }
        }
        
        // we also need a field for 
        protected Action<EventData> InputAction; 
        protected EventHandlerAgent(Behaviour parent) : base(parent)
        {
            // empty... 
        }

        public override void Dispose()
        {
            // why does this happen base.Dispose()... 
            if (InputAction != null)
            {
                // remove from the lsit?? 
                // InputAction = null; 
            }
            base.Dispose();
            
        }
    }

    public class AxisAgent : EventHandlerAgent
    {
        public AxisAgent(Behaviour parent) : base(parent)
        {
        }
    }

    private void Update()
    {
        // we need to use the var keyword when doing a for loop for readability, as it's "obvious" from the RHS what the type should be
        // getting each method (attached to this script) umm I'm getting the non-public ones as well I'm not sure this is good practise
        foreach (var method in GetType().GetMethods(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic))
        {
            var attributes = method.GetCustomAttributes(typeof(CustomInputAttribute), false);
            
            // check to see if any attributes are returned 
            if (attributes.Length > 0)
            {
                var attribute = attributes[0] as CustomInputAttribute;

                // hmm this is really bad code, the attribute could be null
                if (Input.GetKeyDown(attribute.Key))
                {
                    method.Invoke(this, null);
                }
            }
        }
        
    }

    /*[CustomInput(KeyCode.A)]
    public void Test()
    {
        Debug.LogFormat("This method has been invoked");
    }#1#
}
*/

