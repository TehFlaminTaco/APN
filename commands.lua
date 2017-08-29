local t
local truthy = function(a)
	if a == nil then
		return false
	end
	if type(a) == "number" then
		return a ~= 0
	elseif type(a) == "string" or type(a) == "table" then
		return #a > 0
	else
		return ~~a
	end
end
t={
	['0'] = function()return 0 end,
	['1'] = function()return 1 end,
	['2'] = function()return 2 end,
	['3'] = function()return 3 end,
	['4'] = function()return 4 end,
	['5'] = function()return 5 end,
	['6'] = function()return 6 end,
	['7'] = function()return 7 end,
	['8'] = function()return 8 end,
	['9'] = function()return 9 end,

	['['] = function(a)end,
	[']'] = function(a)return a, a end,

	['='] = function(b,a)
		if type(b)~="function"then
			local v = b
			b = function() return v end
		end
		t[a] = b
	end,
	[';'] = function(a, b)
		if(type(a)~="function")then
			a,b=b,a
		end
		if(type(a)~="function")then
			return b,a
		end
		if(type(b)=="number")then
			for i=1, b do
				a(i)
			end
		end
		if(type(b)=="string")then
			for s in b:gmatch"." do
				a(s)
			end
		end
		if(type(b)=="table")then
			for k,v in ipairs(b) do
				a(v)
			end
		end
		if(type(b)=="function")then
			for v in b do
				a(v)
			end
		end
	end,
	[':'] = function(a)
		repeat until not truthy(a())
	end,
	['?'] = function(a,b,c)
		if truthy(a) then
			return b()
		else
			return c()
		end
	end,

	['+'] = function(a,b)return a+b end,
	['-'] = function(a,b)return a-b end,
	['*'] = function(a,b)return a*b end,
	['/'] = function(a,b)return a/b end,
	['.'] = function(a,b)return a..b end,
	['>'] = function(a,b)return a > b and 1 or 0 end,
	['<'] = function(a,b)return a < b and 1 or 0 end,

	['°'] = function(g)
		if(type(g)=="function")then
			local inf = debug.getinfo(g)
			local n = inf.isvararg and -1 or inf.nparams
			return function()
				local t = {}
				if n ~= -1 then
					for i=1, n do
						t[i] = 0
					end
				end
				return g(table.unpack(t))
			end
		end
	end,
	['¹'] = function(g)
		if(type(g)=="function")then
			local inf = debug.getinfo(g)
			local n = inf.isvararg and -1 or inf.nparams
			return function(a)
				local t = {a}
				if n ~= -1 then
					for i=2, n do
						t[i] = a
					end
				end
				return g(table.unpack(t))
			end
		end
	end,
	['²'] = function(g)
		if(type(g)=="function")then
			local inf = debug.getinfo(g)
			local n = inf.isvararg and -1 or inf.nparams
			return function(a,b)
				local t = {a,b}
				if n ~= -1 then
					for i=3, n do
						t[i] = a
					end
				end
				return g(table.unpack(t))
			end
		end
	end,
	['³'] = function(g)
		if(type(g)=="function")then
			local inf = debug.getinfo(g)
			local n = inf.isvararg and -1 or inf.nparams
			return function(a,b,c)
				local t = {a,b,c}
				if n ~= -1 then
					for i=4, n do
						t[i] = a
					end
				end
				return g(table.unpack(t))
			end
		end
	end,

	r = function(a,b,c)
		if type(a) == "table" then
			local oT = {}
			for k,v in pairs(a) do
				oT[k] = type(c)=="function" and c(v) or c
			end
			return oT
		else
			return tostring(a):gsub(b,c)
		end
	end,
	R = function(a)
		local t = {}
		for i=1, a do
			t[i] = i
		end
		return t
	end,
	t = function(a,b)
		local t = {}
		for i=a, b, a<b and 1 or -1 do
			t[#t+1] = i
		end
		return t
	end,

	p = function(a)
		print(a)
	end
}

return t;