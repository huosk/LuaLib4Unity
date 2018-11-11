using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;

[CSharpCallLua]
public delegate void LuaAction();

[CSharpCallLua]
public delegate void LuaFloatAction(float f);

public class UnityEventDispatcher : Singleton<UnityEventDispatcher>
{
    public LuaFloatAction onUpdate;
    public LuaAction onLateUpdate;
    public LuaAction onFixedUpdate;

    void Update()
    {
        if (onUpdate != null)
            onUpdate(Time.deltaTime);
    }

    void LateUpdate()
    {
        if (onLateUpdate != null)
            onLateUpdate();
    }

    void FixedUpdate()
    {
        if (onFixedUpdate != null)
            onFixedUpdate();
    }

    void OnDestroy()
    {
        onUpdate = null;
        onLateUpdate = null;
        onFixedUpdate = null;
    }
}
