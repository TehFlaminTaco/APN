arg[-1] = arg[0]:match".*/" or ""
arg[-1] = arg[-1]:gsub("\\", "."):gsub("/", ".")
local r = require;
function require(a)
	return r(arg[-1]..a)
end

commands = require"commands"

--print(debug.getinfo(commands["+"]).nparams)

function eval(inp, ...)
	local t = {}
	local oInp = ""
	while #inp > 0 and inp ~= oInp do
		local c = inp:sub(1,1)
		inp = inp:sub(2)
		if c == '$' then
			local n
			n,inp = inp:match"(%d*)(.*)"
			t[#t+1] = function()return function()return tonumber(n)end end
		elseif c == '#' then
			local n
			n,inp = inp:match"(.)(.*)"
			t[#t+1] = function()return function()return commands[n]end end
		elseif c == '`' then
			local n
			n,inp = inp:match"(.)(.*)"
			t[#t+1] = function()return function()return n end end
		elseif c == "'" then
			local n
			n,inp = inp:match"([^']*)'(.*)"
			t[#t+1] = function()return function()return n end end
		elseif c == '"' then
			local n
			n,inp = inp:match'([^"]*)"(.*)'
			t[#t+1] = function()return function()return n end end
		elseif c == "{" then
			local n
			n,inp = (c..inp):match'(%b{})(.*)'
			t[#t+1] = function()return function()return function(...)return eval(n:sub(2,-2), ...) end end end
		elseif c == "(" then
			local n
			n,inp = (c..inp):match'(%b())(.*)'
			t[#t+1] = function()return function()return eval(n:sub(2,-2)) end end
		else
			t[#t+1] = function()return commands[c] or function()end end
		end
	end
	local storedVars = {...}
	local storedFuncs = t
	while #t > 0 do
		storedFuncs = {}
		for i=1, #t do
			local inf = debug.getinfo(t[i]())
			local n = inf.nparams
			if inf.isvararg then
				storedVars = {t[i]()(table.unpack(storedVars))}
				for i=i+1, #t do
					storedFuncs[#storedFuncs+1] = t[i]
				end
				break
			elseif(#storedVars < n)then
				storedFuncs[#storedFuncs+1] = t[i]
			else
				local sub = {}
				for i=1, n do
					sub[n-(i-1)] = storedVars[#storedVars]
					table.remove(storedVars, #storedVars)
				end
				local vs = {t[i]()(table.unpack(sub))}
				for k,v in pairs(vs) do
					storedVars[#storedVars+1] = v
				end
				for i=i+1, #t do
					storedFuncs[#storedFuncs+1] = t[i]
				end
				break
			end
		end
		t = storedFuncs
	end

	return table.unpack(storedVars)
end

local storedVars = {eval([[
`x = 6
:{
	p x
	`x = (x-1)
	x
}
]])}
local s = ""
local o = ""
for k,v in pairs(storedVars) do
	s = s .. o .. tostring(v)
	o = "\n"
end
io.write(s)