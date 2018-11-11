using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading;

public abstract class Singleton<T> : MonoBehaviour
    where T : Singleton<T>
{
    public static T instance
    {
        get
        {
            if (_instance == null)
                CreateNew();
            return _instance;
        }
    }

    private static T _instance;

    private void Awake()
    {
        if (_instance == null)
            _instance = this as T;
        else
        {
            DestroyImmediate(this);
        }
    }

    private static void CreateNew()
    {
        if (_instance != null)
            return;

        GameObject go = new GameObject(typeof(T).Name);
        DontDestroyOnLoad(go);
        Interlocked.CompareExchange(ref _instance, go.AddComponent<T>(), null);
    }

    public void Dispose()
    {
        if (_instance == null || _instance != this)
            return;

        DestroyImmediate(gameObject);
        _instance = null;
    }
}
