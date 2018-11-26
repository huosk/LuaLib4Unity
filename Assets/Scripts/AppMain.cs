using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System;

public class AppMain : AppLuaBase
{
    LuaTable mainTable;

    // Use this for initialization
    void Start()
    {
        luaEnv.AddLoader(LuaLoader.LoaderProxy);
        mainTable = luaEnv.DoString("return require 'Main'")[0] as LuaTable;
        mainTable.Set("writePath", AppPath.writePath);
        mainTable.Set("cachePath", AppPath.cachePath);
        mainTable.Set("buildinResPath", AppPath.buildinResPath);
        mainTable.Set("resPath", AppPath.resPath);
        mainTable.Set("cfgPath", AppPath.cfgPath);
        mainTable.Set("gameObject", gameObject);
        mainTable.Set("component", this);

        LoadCompileCondition(luaEnv.Global);

        var init = mainTable.Get<LuaFunction>("Init");
        if (init != null) init.Call();
    }

    void LoadCompileCondition(LuaTable toTable)
    {
        bool isUnity2018 = false;
        bool isUnity2017 = false;
        bool isUnity5 = false;
        bool isUnity4 = false;
        bool isAndroid = false;
        bool isIOS = false;
        bool isWebGL = false;
        bool isStandlone = false;
        bool isStandloneOSX = false;
        bool isStandloneWin = false;
        bool isEditor = false;
        bool isEditorOSX = false;
        bool isEditorWin = false;

#if UNITY_EDITOR
        isEditor = true;
#endif

#if UNITY_EDITOR_WIN
        isEditorWin = true;
#endif

#if UNITY_EDITOR_OSX
        isEditorOSX = true;
#endif

#if UNITY_STANDALONE
        isStandlone = true;
#endif

#if UNITY_STANDALONE_WIN
        isStandloneWin = true;
#endif

#if UNITY_STANDALONE_OSX
        isEditorOSX = true;
#endif

#if UNITY_IOS
        isIOS = true;
#endif

#if UNITY_ANDROID
        isAndroid = true;
#endif

#if UNITY_WEBGL
        isWebGL = true;
#endif

#if UNITY_2018
        isUnity2018 = true;
#elif UNITY_2017
        isUnity2017 = true;
#elif UNITY_5
        isUnity5 = true;
#elif UNITY_4
        isUnity4 = true
#endif

        toTable.Set("UNITY_2018", isUnity2018);
        toTable.Set("UNITY_2017", isUnity2017);
        toTable.Set("UNITY_5", isUnity5);
        toTable.Set("UNITY_4", isUnity4);
        toTable.Set("UNITY_EDITOR", isEditor);
        toTable.Set("UNITY_EDITOR_WIN", isEditorWin);
        toTable.Set("UNITY_EDITOR_OSX", isEditorOSX);
        toTable.Set("UNITY_STANDLONE", isStandlone);
        toTable.Set("UNITY_STANDLONE_WIN", isStandloneWin);
        toTable.Set("UNITY_STANDLONE_OSX", isStandloneOSX);
        toTable.Set("UNITY_ANDROID", isAndroid);
        toTable.Set("UNITY_IOS", isIOS);
        toTable.Set("UNITY_WEBGL", isWebGL);
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
