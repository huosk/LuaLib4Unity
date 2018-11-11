---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by SK.
--- DateTime: 2018/10/25 16:25
---Lua 事件分发模块

local module = {events = {}}

---检测是否存在指定名称的事件
---@param eventName 要检测的事件的名称
---@return boolean
function module:ContainsEvent(eventName)
    if self.events ~= nil then
        return self.events[eventName] ~= nil
    else
        return false
    end
end

---查找指定名称的事件
---@param eventName 要查找的事件的名称
---@return 找到的事件或者nil
function module:FindEvent(eventName)
    if self.events == nil then
        return nil
    else
        return self.events[eventName]
    end
end

---创建事件表
local function CreateEventTable(eventName)

    ---@class Event
    ---@field eventName 事件的名称
    local evt = {eventName = eventName}
    local listeners = {}

    ---添加事件监听
    ---@param lsn fun(...) 监听函数
    ---@return boolean 是否添加成功
    function evt:AddListener(lsn)
        assert(lsn ~= nil,"The listener is nil")

        --如果监听函数列表为空，则创建一个列表
        if listeners == nil then
            listeners = {}
        end

        --将监听插入列表中
        table.insert(listeners,lsn)

        return true
    end

    ---删除事件监听
    ---@param lsn fun(...) 需要删除的监听
    function evt:RemoveListener(lsn)
        assert(lsn ~= nil,"The listener is nil")

        if listeners == nil then
            return
        end

        --遍历整个监听表
        local index = 1
        while(index <= #listeners) do
            if listeners[index] == nil or listeners[index] == lsn then
                table.remove(listeners,index)
            else
                index = index + 1
            end
        end
    end

    ---清除所有的监听
    function evt:ClearListener()
        listeners = {}
    end

    ---触发事件
    ---param ... 向监听传递的参数
    function evt:Dispatch(...)
        --没有监听不作处理
        if listeners == nil then
            return
        end

        for k,v in pairs(listeners) do
            if v~= nil then
                v(...)
            end
        end
    end

    return evt
end

---创建事件
---@param eventName 指定要创建事件的名称
---@return Event 返回创建完成的事件
function module:CreateEvent(eventName)
    assert(eventName ~= nil,"LuaEventDispatcher.CreateEvent:eventName cannot be nil")

    --检测相同名称的事件是否存在
    if self:ContainsEvent(eventName) then
        error("LuaEventDispatcher.CreateEvent:the same name has exist,event name:"..eventName)
        return nil
    end

    local evt = CreateEventTable(eventName)

    if self.events == nil then
        self.events = {}
    end

    self.events[eventName]  = evt

    return evt
end

---添加事件监听
---@param eventName 事件名称
---@param lsn fun(...) 监听函数
function module:AddEventListener(eventName,lsn)
    assert(eventName ~= nil,"LuaEventDispatcher.AddEventListener:eventName cannot be nil")
    local evt = self:FindEvent(eventName)
    if evt == nil then
        error("Cannot find the event with name :"..eventName)
        return
    else
        return evt:AddListener(lsn)
    end
end

---移除事件监听
---@param eventName 事件名称
---@param lsn 监听函数
function module:RemoveEventListener(eventName,lsn)
    assert(eventName ~= nil,"LuaEventDispatcher.RemoveEventListener:eventName cannot be nil")
    local evt = self:FindEvent(eventName)
    if evt ~= nil then
        evt:RemoveListener(lsn)
    end
end

---触发指定名称的事件
---@param eventName 事件名称
function module:DispatchEvent(eventName,...)
    assert(eventName ~= nil,"LuaEventDispatcher.ExcuteEvent:eventName cannot be nil")
    local evt = self:FindEvent(eventName)
    if evt == nil then
        error("Cannot find the event with name :"..eventName)
    else
        evt:Dispatch(...)
    end
end

---删除事件
---@param eventName 要删除的事件的名称
function module:RemoveEvent(eventName)
    assert(eventName ~= nil,"LuaEventDispatcher.RemoveEvent:eventName cannot be nil")
    local evt = self:FindEvent(eventName)
    if evt ~= nil then
        evt:ClearListener()
        self.events[eventName] = nil
    end
end

---获取事件的个数
---@return number
function module:GetEventCount()
    if self.events == nil then
        return 0
    else
        local count = 0
        for k,v in pairs(self.events) do
            if v ~= nil then
                count = count + 1
            end
        end
        return count
    end
end

return module