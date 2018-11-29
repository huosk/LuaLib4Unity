---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by SK.
--- DateTime: 2018/11/27 9:30
---

local ticker = CS.UnityEventDispatcher.instance
local tbUtil = require("Util.TableUtil")
local logger = require("Logger")

---创建Ticker
---@return UnityTicker
local function UnityTicker()

    ---@type TickEntry[]
    local updateList={}

    ---@type TickEntry[]
    local lateUpdateList={}

    ---@type TickEntry[]
    local fixedUpdateList={}

    local function CreateNewEntry(fun)
        assert(fun~=nil,"Nil argument::fun")
        assert(type(fun) == "function","Invalid argument::fun")

        ---@class TickEntry
        ---@field func fun(...):void
        ---@field state table
        ---@field Tick fun():void
        local entry = {func = fun,state=nil}

        ---执行存储的方法
        function entry:Tick()
            if self.func then
                xpcall(self.func, function(err)
                    logger:Error(tostring(err).."\n"..debug.traceback())
                    return err
                end,self.state)
            end
        end

        local meta = {}
        meta.__eq = function(r,l)
            if not r or not l then
                return false
            end

            return r.func == l.func
        end

        setmetatable(entry,meta)
        return entry
    end

    ---向列表中添加条目
    ---@param list TickEntry[]
    ---@param func fun(...):void
    ---@param state table 向fun传递的参数
    ---@return boolean
    local function AddListener(list,func,state)
        assert(list~=nil,"Nil argument::list")
        assert(func~= nil,"Nil argument::fuc")
        local entry = CreateNewEntry(func)
        entry.state = state
        table.insert(list,entry)
    end

    ---从列表中查找指定条目
    ---@param list TickEntry[]
    ---@param func fun(...):void
    ---@param int,TickEntry
    local function GetListener(list,func)
        assert(list~=nil,"Nil argument::list")
        assert(func~= nil,"Nil argument::fuc")
        local index = 0
        local entry = nil
        for i=1,#list do
            if list[i] and list[i].func == func then
                index = i
                entry = list[i]
                break
            end
        end
        return index,entry
    end

    ---从列表中删除对应条目
    ---@param list TickEntry[]
    ---@param func fun(...):void
    local function RemoveListener(list,func)
        assert(list~=nil,"Nil argument::list")
        assert(func~= nil,"Nil argument::fuc")

        tbUtil.RemoveAll(list, function(v)
            return v ~= nil and v.func == func
        end)
    end

    ---逐元素调用列表中的条目
    ---@param list TickEntry[]
    local function Tick(list)
        assert(list ~= nil,"Nil argument::list")
        for i=1,#list do
            if list[i] and list[i].func then
                list[i]:Tick()
            end
        end
    end

    ticker.onUpdate = function(delta) Tick(updateList) end
    ticker.onLateUpdate = function() Tick(lateUpdateList) end
    ticker.onFixedUpdate = function() Tick(fixedUpdateList) end

    ---@class UnityTicker
    local looper = {}

    ---向 UnityUpdate 注册监听
    ---@param func fun(...):void
    ---@param ... table
    function looper:StartListenUpdate(func,...)
        AddListener(updateList,func,...)
    end

    ---向 UnityLateUpdate 注册监听
    ---@param func fun(...):void
    ---@param ... table
    function looper:StartListenLateUpdate(func,...)
        AddListener(lateUpdateList,func,...)
    end

    ---向 UnityFixedUpdate 注册监听
    ---@param func fun(...):void
    ---@param ... table
    function looper:StartListenFixedUpdate(func, ...)
        AddListener(fixedUpdateList,func,...)
    end

    ---注销UnityUpdate 监听
    ---@param func fun(...):void
    function looper:StopListenUpdate(func)
        RemoveListener(updateList,func)
    end

    ---注销UnityLateUpdate 监听
    ---@param func fun(...):void
    function looper:StopListenLateUpdate(func)
        RemoveListener(lateUpdateList,func)
    end

    ---注销UnityFixedUpdate 监听
    ---@param func fun(...):void
    function looper:StopListenFixedUpdate(func)
        RemoveListener(fixedUpdateList,func)
    end

    ---检测方法是否在 Update 注册列表中
    ---@param func fun(...):void
    function looper:IsUpdating(func)
        local idx = GetListener(updateList,func)
        return idx > 0
    end

    ---检测方法是否在 LateUpdate 注册列表中
    ---@param func fun(...):void
    function looper:IsLateUpdating(func)
        local idx = GetListener(lateUpdateList,func)
        return idx > 0
    end

    ---检测方法是否在 FixedUpdate 注册列表中
    ---@param func fun(...):void
    function looper:IsFixedUpdating(func)
        local idx = GetListener(fixedUpdateList, func)
        return idx > 0
    end

    return looper
end

local single = UnityTicker()
return single