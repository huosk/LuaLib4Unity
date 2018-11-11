using UnityEngine;
using System.Collections;
using XLua;

public abstract class AppLuaBase : MonoBehaviour
{

    public static LuaEnv luaEnv
    {
        get
        {
            return _luaEnv;
        }
    }

    private static readonly LuaEnv _luaEnv = new LuaEnv();
}
