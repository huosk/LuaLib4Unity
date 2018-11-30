---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by SK.
--- DateTime: 2018/11/26 12:03
---

---@class AssetType
AssetType = { Unknown = 0,
              Material = 1,
              Texture = 2,
              GameObject = 3,
              Text = 4,
              Sound = 5 }

---将AssetType 类型转换为 CS.System.Type 类型
---@param type AssetType
---@return CS.System.Type
function AssetTypeToCSType(type)
    if type == AssetType.GameObject then
        return typeof(CS.UnityEngine.GameObject)
    elseif type == AssetType.Texture then
        return typeof(CS.UnityEngine.Texture2D)
    elseif type == AssetType.Text then
        return typeof(CS.UnityEngine.TextAsset)
    elseif type == AssetType.Material then
        return typeof(CS.UnityEngine.Material)
    elseif type == AssetType.Sound then
        return typeof(CS.UnityEngine.AudioClip)
    end
end