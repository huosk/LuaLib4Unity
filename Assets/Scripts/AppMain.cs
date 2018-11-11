using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;

public class AppMain : AppLuaBase 
{
    LuaTable mainTable;

    // Use this for initialization
    void Start () 
    {
        luaEnv.AddLoader(LuaLoader.LoaderProxy);
        mainTable = luaEnv.DoString("return require 'Main'")[0] as LuaTable;
        mainTable.Set("writePath", AppPath.writePath);
        mainTable.Set("cachePath", AppPath.cachePath);
        mainTable.Set("buildinResPath", AppPath.buildinResPath);
        mainTable.Set("resPath", AppPath.resPath);
        mainTable.Set("cfgPath", AppPath.cfgPath);
        mainTable.Set("gameObject", gameObject);
        mainTable.Set("component",this);

        var init = mainTable.Get<LuaFunction>("Init");
        if (init != null) init.Call();
    }

    void Update()
    {
        if (luaEnv != null)
            luaEnv.Tick();
    }

    void OnDestroy()
    {
        var dispose = mainTable.Get<LuaFunction>("Dispose");
        if (dispose != null) dispose.Call();
    }
}
