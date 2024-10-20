using System;
using System.Reflection;
using System.Collections.Generic;
using UnityEngine;

namespace Bedrock
{
    public class BedrockElement : MonoBehaviour
    {
        
        private static Dictionary<Type, Dictionary<MemberInfo, Attribute[]>> memberBufferDictionary = new Dictionary<Type, Dictionary<MemberInfo, Attribute[]>>();

        /// <summary>
        /// Awake function can be overriden by base classes
        /// </summary>
        protected void Awake()
        {
            // populate the attribute dictionary 
        }

        private void InitManagerAgents()
        {
            Type originationType = GetType();
            
            // aggregate the custom attributes for the origination type 
            // only if we haven't populated the dic for that class already
            // since this function should only be called once per class (due to Awake()) 
            if (!memberBufferDictionary.ContainsKey(originationType))
            {
                memberBufferDictionary.Add(originationType, new Dictionary<MemberInfo, Attribute[]>());
                MemberInfo[] members = originationType.GetMembers(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                foreach (MemberInfo memberInfo in members)
                {
                    memberBufferDictionary[originationType].Add(memberInfo, Attribute.GetCustomAttributes(memberInfo, typeof(Attribute), false));
                }
            }
            
            // use the result of the aggregation to set up the Manager Agents
            
        }
    }
}

