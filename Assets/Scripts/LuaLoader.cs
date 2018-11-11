using UnityEngine;
using System.Collections;
using System.IO;

public sealed class LuaLoader
{

    public static byte[] LoaderProxy(ref string file)
    {
#if UNITY_EDITOR
        return LoadInEditor(ref file);
#else
        return LoadLua(ref file);
#endif
    }


    private static byte[] LoadInEditor(ref string file)
    {
        if (string.IsNullOrEmpty(file))
            return null;

        string finalfile = Path.ChangeExtension(file.Replace('.', '/'), ".lua");

        if (!Directory.Exists(AppPath.resPath))
            return null;

        string fullfile = string.Concat(AppPath.resPath, finalfile);
        return File.ReadAllBytes(fullfile);
    }


    private static byte[] LoadLua(ref string file)
    {
        throw (new System.NotImplementedException());
    }
}
