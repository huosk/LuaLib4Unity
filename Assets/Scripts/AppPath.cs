using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppPath
{
    /// <summary>
    /// 可写入资源文件的路径
    /// </summary>
    /// <value>The write path.</value>
    public static string writePath
    {
        get
        {
            if (string.IsNullOrEmpty(_writePath))
                _writePath = Application.persistentDataPath;
            return _writePath;
        }
    }


    /// <summary>
    /// 可读写的缓存目录，这个目录的内容可能被用户清理掉
    /// 所以如果需要进行持久保存的文件，需要使用 writePath
    /// </summary>
    /// <value>The cache path.</value>
    public static string cachePath
    {
        get
        {
            if (string.IsNullOrEmpty(_cachePath))
                _cachePath = Application.temporaryCachePath;
            return _cachePath;
        }
    }

    /// <summary>
    /// 内置资源路径
    /// </summary>
    /// <value>The buildin res path.</value>
    public static string buildinResPath
    {
        get
        {
            if (string.IsNullOrEmpty(_buildinResPath))
                _buildinResPath = Application.streamingAssetsPath;
            return _buildinResPath;
        }
    }

    /// <summary>
    /// 资源存放路径
    /// </summary>
    /// <value>The res path.</value>
    public static string resPath
    {
        get
        {
            if (string.IsNullOrEmpty(_resPath))
                _resPath = string.Concat(Application.streamingAssetsPath, "/res/");
            return _resPath;
        }
    }

    /// <summary>
    /// 配置文件存放路径
    /// </summary>
    /// <value>The cfg path.</value>
    public static string cfgPath
    {
        get
        {
            if (string.IsNullOrEmpty(_cfgPath))
                _cfgPath = string.Concat(Application.streamingAssetsPath, "/config/");
            return _cfgPath;
        }
    }

    private static string _buildinResPath;
    private static string _writePath;
    private static string _resPath;
    private static string _cfgPath;
    private static string _cachePath;

    public static string luaPath
    {
        get
        {
            return string.Concat(resPath, "/lua/");
        }
    }
}
