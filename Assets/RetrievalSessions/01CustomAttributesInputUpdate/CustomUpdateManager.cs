/*
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using CustomAttributes;
using UnityEngine;

public class CustomUpdateManager : MonoBehaviour
{
    // 02/08/24 - let's create an agent - nested class 
    public class UpdateAgent : Agent
    {
        private Action UpdateAction;

        private CustomUpdateAttribute.UpdateType _type; 
        
        // constructor chaining 
        public UpdateAgent(Behaviour parent, CustomUpdateAttribute attribute, Action action) : base(parent)
        {
            // existence check for parent handled in base class 
            if (base.isFinished)
            {
                return; 
            }
            
            // creation of the delegate with the passed in action 
            // and appropriate checks including the ACTIVE check
            UpdateAction = delegate
            {
                if (!isFinished && parent.isActiveAndEnabled)
                {
                    action();
                }
            };
            
            // set default type to be Normal update 
            // TODO - could implement custom attributes for the specfic update types 
            // but not sure in what use cases the other ones (FIXED LATE) would be used
            if (attribute == null)
            {
                _type = CustomUpdateAttribute.UpdateType.NORMAL; 
            }
            else
            {
                _type = attribute.Type;
            }
            
            // TODO - logic for adding the event to a list with the corresponding priority (attached to attribute)
            // for now we have placeholder code: Note that it doesn't work because the lists are lists of type 
            // MethodInfos rather than actions 
            /* foreach (var attribute in attributes) 
              {
                switch (attribute.Type)
                {
                    case CustomUpdateAttribute.UpdateType.NORMAL:
                        normalUpdates.Add(UpdateAction);
                        break;
                    case CustomUpdateAttribute.UpdateType.FIXED:
                        fixedUpdates.Add(method);
                        break;
                    case CustomUpdateAttribute.UpdateType.LATE:
                        lateUpdates.Add(method);
                        break;
                }
            }#1#

        }

        public override void Dispose()
        {
            base.Dispose();
            if (UpdateAction != null)
            {
                // TODO - remove this action from the corresponding from the event list (done when implementing PrioritizedActionListADT) 
                // UpdateAction = null;
            }
        }
    }
    

    // SIMPLIFIED MODEL - AGAIN WITH THE SAME LIMITATIONS AS CUSTOM INPUT MANAGER 
    // three lists 
    private static List<MethodInfo> normalUpdates = new List<MethodInfo>();
    private static List<MethodInfo> fixedUpdates = new List<MethodInfo>();
    private static List<MethodInfo> lateUpdates = new List<MethodInfo>();

    // Do reflection in awake
    private void Awake()
    {
        SetUpdateListsFromMethods();

    }

    private void Update()
    {
        InvokeMethods(normalUpdates);
    }

    private void LateUpdate()
    {
        InvokeMethods(lateUpdates);
    }

    private void FixedUpdate()
    {
        InvokeMethods(fixedUpdates);
    }

    private void SetUpdateListsFromMethods()
    {
        foreach (var method in GetType()
                     .GetMethods(BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public))
        {
            var attributes =
                method.GetCustomAttributes(typeof(CustomUpdateAttribute), false) as CustomUpdateAttribute[];
            // lots of warnings here about attributes being Null, yup, this is very bad code hmm 
            foreach (var attribute in attributes)
            {
                switch (attribute.Type)
                {
                    case CustomUpdateAttribute.UpdateType.NORMAL:
                        normalUpdates.Add(method);
                        break;
                    case CustomUpdateAttribute.UpdateType.FIXED:
                        fixedUpdates.Add(method);
                        break;
                    case CustomUpdateAttribute.UpdateType.LATE:
                        lateUpdates.Add(method);
                        break;
                }
            }
        }
    }

    private void InvokeMethods(List<MethodInfo> methodInfos)
    {
        foreach (var method in methodInfos)
        {
            method.Invoke(this, null);
        }
    }
    
    [CustomUpdate(CustomUpdateAttribute.UpdateType.NORMAL)]
    public void Test()
    {
        Debug.LogFormat("This NORMAL method has been invoked");
    }
}
*/
