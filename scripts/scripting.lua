Scripting = {}

require "console"

local test = 42

function Scripting.Initialize()
	Engine:RegisterCommand("lua", "scripting console usage", Scripting.OnCmdLua)
	Engine:RegisterCVar("test", "keawdk", { "int" }, function() return { test } end, function(A) test = A[1] end)
end

function Scripting.OnCmdLua(Args)
	local cmds = 
	{ 
		{
			Name = "do",
			Description = "execute script",
			Args = { "string/file" },
			Callback = function()
				for i = 2, #Args do
					load(Args[i])()
				end
			end
		},
		
		{
			Name = "version",
			Description = "show lua interpreter version",
			Args = {},
			Callback = function()
				Engine:WriteLine(_VERSION)
			end
		}
	}
	
	if #Args == 0 then
		Engine:WriteLine("Syntax: lua <cmd>")
		Engine:WriteLine("Syntax: lua <cmd> <arg>")
		Engine:WriteLine("")
		Engine:WriteLine("Commands:")
		
		for i = 1, #cmds do
			Engine:WriteLine(" " .. i .. ") " .. cmds[i].Name .. " - " .. cmds[i].Description)
		end

		return
	end
	
	local name = Args[1]
	
	for i = 1, #cmds do
		local cmd = cmds[i]
	
		if cmd.Name == name then
			if #cmd.Args > #Args - 1 then
				Engine:WriteLine("Syntax: lua " .. cmd.Name .. " <" .. table.concat(cmd.Args, "> <") .. ">")
			else
				cmd.Callback()
			end
			
			return
		end
	end

	Engine:WriteLine('Unknown lua command: "' .. name .. '"')
end