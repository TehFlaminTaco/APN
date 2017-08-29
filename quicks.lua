return {
	['#'] = function(t, i)
		table.remove(t,i)
		local f = t[i] or function()end
		if(type(f)=="function")then
			t[i] = function()return function()return f()end end
		else
			table.insert(t,i,'#')
			return true
		end
	end,
	['{'] = function(t,i)
		local d = 1
		local l = {}
		table.remove(t,i)
		while d > 0 and #t>=i do
			local e = table.remove(t,i)
			if e == "{" then
				d = d + 1
			elseif e == "}" then
				d = d - 1
			end
			l[#l+1] = e
		end
		table.insert(t,i, function()return function() return function(...)return eval(l, ...)end end end)
	end,
	['}'] = function(t,i)
		table.remove(t,i)
		table.insert(t,i,function()return function() end end)
	end,
	['('] = function(t,i)
		local d = 1
		local l = {}
		table.remove(t,i)
		while d > 0 and #t>=i do
			local e = table.remove(t,i)
			if e == "(" then
				d = d + 1
			elseif e == ")" then
				d = d - 1
			end
			l[#l+1] = e
		end
		table.insert(t,i, function() return function()return eval(l)end end)
	end,
	[')'] = function(t,i)
		table.remove(t,i)
		table.insert(t,i,function()return function() end end)
	end
}