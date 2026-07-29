--- Factory function creating lightweight OOP class structures with single inheritance and type checking.
---@param base? table Optional base class table to inherit from.
---@return Class class_table The constructed class object equipped with constructor instantiation and inheritance utilities.
local function new_class(base)
    ---@class Class
    ---@field ancestors table<table, boolean> Lookup table of all inherited ancestor classes.
    local class_table = {}
    class_table.__index = class_table

    class_table.ancestors = {}
    class_table.ancestors[class_table] = true

    -- Inherit ancestors and metatable index if base class is provided
    if type(base) == "table" then
        for k, v in pairs(base.ancestors) do
            class_table.ancestors[k] = v
        end

        class_table.ancestors[base] = true
        setmetatable(class_table, { __index = base })
    end

    --- Default constructor callback executed upon instance creation.
    --- Override this method in derived classes to perform initialization.
    ---@param ... any Arguments passed when instantiating the class.
    function class_table:init(...)

    end

    --- Creates a subclass extending from this class.
    ---@param subclass? table Optional table to convert into a subclass.
    ---@return table subclass The newly created subclass.
    function class_table.extend(subclass)
        return new_class(subclass or class_table)
    end

    --- Checks whether an instance or class inherits from or matches the specified target class.
    ---@param target_class table The target class table to check against.
    ---@return boolean isSubclass True if the target class exists in the inheritance hierarchy.
    function class_table:is(target_class)
        return self.ancestors[target_class] == true
    end

    local mt = {
        --- Instantiates the class as an object and invokes its `init` constructor if defined.
        ---@param self table
        ---@param ... any Arguments passed directly to the constructor method (`init`).
        ---@return table instance The instantiated object with this class set as its metatable.
        __call = function(self, ...)
            local instance = setmetatable({}, class_table)
            if instance.init then instance:init(...) end
            return instance
        end
    }

    return setmetatable(class_table, mt)
end

return new_class