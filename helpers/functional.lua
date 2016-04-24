fun = {}
fun._meta = {__index = fun}
fun.bound_functions = {}

function fun.attach_to( _, obj )
	if type(obj) == "table" then
		setmetatable(obj, fun._meta)
	end
	return obj
end

setmetatable(fun, {
	__index = fun.bound_functions,
	__call = fun.attach_to
})

function fun.curryleft( fn, fixedval )
	return function( ... )
		return fn(fixedval, unpack({...}))
	end
end

function fun.curry( fn, fixedval )
	return function( ... )
		return fn(unpack({...}), fixedval)
	end
end

function fun.tabulate( fn )
	local _i = 0
	return function(a)
		_i = _i + 1
		return fn(_i-1)
	end
end

function fun.spy( fn )
	local spy = {
		count = 0,
		last_args = {}
	}
	setmetatable(spy, {
		__call = function(_, ...)
			spy.count = spy.count + 1
			spy.last_args = {...}
			return fn(...)
		end
	})
	return spy
end

function fun.call( fn, ... )
	return fn(...)
end

function fun.push( items, value, key )
	if key and type(key) == "number" then
		table.insert(items, value)
	else
		items[key] = value
	end
	return fun(items)
end

function fun.compose( ... )
	local fns = {...}
	return function(...)
		local last = {...}
		for i = 1, #fns do
			last = {fns[i](unpack(last))}
		end
		return unpack(last)
	end
end

function fun.map( items, fn )
    local out = {}
    for k, v in pairs(items) do
        out[k] = fn(v, k, items)
    end
    return fun(out)
end

function fun.for_each( items, fn )
	for k, v in pairs(items) do
        fn(v, k, items)
    end
	return fun(items)
end

function fun.filter( items, predicate )
	local out = {}
	for k, v in pairs(items) do
		if predicate(v, k, items) then
			fun.push(out, v, k)
		end
	end
	return fun(out)
end

function fun.difference_left( a, b )
		return fun
			.filter(a, function(aval)
				return fun.every(b, function(bval) return bval ~= aval end)
			end)
end

function fun.difference( a, b )
	return fun
		.difference_left(a, b)
		:concat(fun.difference_left(b, a))
end

function fun.intersect( a, b )
	return fun
		.filter(a, function(aval)
			return fun.any(b, function(bval) return bval == aval end)
		end)
end

function fun.concat( a, b )
	local out = {}
	for k, v in pairs(a) do
		fun.push(out, v, k)
	end
	for k, v in pairs(b) do
		fun.push(out, v, k)
	end
	return fun(out)
end

function fun.reduce( items, fn, initial )
	local reduceOne
	local len = initial and (#items) or (#items-1)
	local offset = initial and (0) or (1)
	reduceOne = function(index, value)
		if (index > len) then
			return value
		end
		return reduceOne(index + 1, fn(value, items[index+offset], index, items))
	end
	return fun(reduceOne(1, initial or items[1]))
end

function fun.every( items, predicate )
	for k, v in pairs(items) do
		if not predicate(v, k, items) then
			return false
		end
	end
	return true
end

function fun.any( items, predicate )
	for k, v in pairs(items) do
	if predicate(v, k, items) then
			return true
		end
	end
	return false
end

function fun.apply( fn )
	return fun.curry(fun.map, fn)
end

function fun.aggregate( items, fn, initial )
	return fun.reduce(items, function(a, b)
		return fn(a, b)
	end, initial)
end

function fun.pluck( items, key )
	return fun.map(items, function(a) return a[key] end)
end

function fun.best( items, fn, initial )
	local compare = function( a , b )
		return fn(a,b) and a or b
	end
	return fun.reduce(items, compare, initial)
end

function fun.array_only( items )
	return fun.filter(items, function(a, key) return type(key) == "number" end)
end

function fun.insert_to( items )
	return function(a) table.insert(items, a) end
end

function fun.to_array( items )
	local out = {}
	local insert = fun.insert_to(out)
	fun.for_each(items, insert)
	return fun(out)
end

function fun.map_key_value( items )
	return fun.map(items, function(v, k)
		return {value = v, key = k}
	end)
end

function fun.shuffle( items )
	return fun(items)
		:to_array()
		:for_each(function(a, index, t)
			local roll = math.random(1, index)
			t[roll], t[index] = t[index], t[roll]
		end)
end

function fun.first( items )
	for i, v in ipairs(items) do
		return fun(v)
	end
	for k, v in pairs(items) do
		return fun(v)
	end
	return fun({})
end

function fun.last( items )
	if #items > 0 then
		return fun(items[#items])
	else
		local last
		for k, v in pairs(items) do
			last = v
		end
		return fun(last)
	end
	return fun({})
end

function fun.zip( a, b )
	return fun.zip_with(a, b, function(_a, _b) return {_a, _b} end)
end

function fun.zip_flat( a, b )
	local out = {}
	for i = 1, math.min(#a, #b) do
		table.insert(out, a[i])
		table.insert(out, b[i])
	end
	return fun(out)
end

function fun.zip_with( a, b, fn )
	local out = {}
	for i = 1, math.min(#a, #b) do
		out[i] = fn(a[i], b[i])
	end
	return fun(out)
end

function fun.select_while( items, predicate )
	local out = {}
	for k, v in pairs(items) do
		if predicate(v, k, items) then
			fun.push(out, v, k)
		else
			break
		end
	end
	return fun(out)
end

function fun.negate_predicate( predicate )
	return function(...) return not predicate(...) end
end

function fun.select_until( items, predicate )
	return fun.select_while(items, fun.negate_predicate(predicate))
end

function fun.bind( name, fn, arg )
	fun.bound_functions[name] = fun.curry(fn, arg)
end

function fun.noop()
end

function fun.prop( obj, key )
	return type(obj) == 'table' and obj[key] or obj
end

function fun.value_or_prop( fn, k )
	local value_or_prop = fun.curry(fun.prop, k)
	return fun.compose(value_or_prop, fn)
end

function fun.eq( b, k )
	local fn = function(a) return a == b end
	return fun.value_or_prop(fn, k)
end

function fun.neq( b, k )
	local fn = function(a) return a ~= b end
	return fun.value_or_prop(fn, k)
end

function fun.gte( b, k )
	local fn = function(a) return a >= b end
	return fun.value_or_prop(fn, k)
end

function fun.gt( b, k )
	local fn = function(a) return a > b end
	return fun.value_or_prop(fn, k)
end

function fun.lt( b, k )
	local fn = function(a) return a < b end
	return fun.value_or_prop(fn, k)
end

function fun.lte( b, k )
	local fn = function(a) return a <= b end
	return fun.value_or_prop(fn, k)
end

function fun.istype( b, k )
	local fn = function(a) return type(a) == b end
	return fun.value_or_prop(fn, k)
end

function fun.len(a)
	return #a
end

function fun.identy(...)
	return ...
end

function fun.sum( items, fn )
	local fn = fn or fun.identy
	return fun.reduce(items, function(a, b)
		return a + fn(b)
	end, 0)
end

------------------------------------------
------------- TESTS ----------------------
------------------------------------------
local function unit_tests()
	function tablestring(t)
		return table.concat(t, ",")
	end

	function assert_equal( value, expected, message, negate )
		if negate and (expected == value) then
			error("Expected not "..tostring(expected)..", got "..tostring(value).."  "..(message or ""))
		elseif not negate and (expected ~= value) then
	        error("Expected "..tostring(expected)..", got "..tostring(value).."  "..(message or ""))
	    end
	    return true
	end

	function assert_table_equal( value, expected, message, negate )
		local equal = true
		if #value ~= #expected then
			equal = false
		else
			for i = 1, #value do
				if value[i] ~= expected[i] then
					equal = false
					break
				end
			end
		end
		if negate and equal then
			error("Expected not "..tablestring(expected)..", got "..tablestring(value).."  "..(message or ""))
		elseif not negate and not equal then
			error("Expected "..tablestring(expected)..", got "..tablestring(value).."  "..(message or ""))
		end
		return true
	end

	function assert_table_not_equal( value, expected, message )
		return assert_table_equal( value, expected, message, true )
	end

	function assert_not_equal( value, expected, message, negate )
		return assert_equal(value, expected, message, true)
	end

	local test = {}

	function test.fun()
		local items = {1, 2, 3}
		local result = fun(items)
		assert_equal(result, items)
		assert_equal(items.map, fun.map)
	end

	function test.spy()
		local somefn = function(a, b, c) return a+b+c end
		somefn = fun.spy(somefn)
		somefn(1,2,3)
		somefn(5,6,7)
		assert_equal(somefn.count, 2)
		assert_table_equal(somefn.last_args, {5,6,7})
	end

	function test.curry()
		local add = function(a,b) return a + b end
		local add5 = fun.curry(add, 5)
		local result = add5(5)
		assert_equal(result, 10)
	end

	function test.curryleft()
		local divide = function(a, b) return a / b end
		local divide100by = fun.curryleft(divide, 100)
		local result = divide100by(2)
		assert_equal(result, 50)
	end

	function test.compose()
		local prefix1 = function(a) return "_" .. a end
		local prefix2 = function(a) return "$" .. a end
		local prefix = fun.compose(prefix1, prefix2)
		local result = prefix("hello")
		assert_equal(result, "$_hello")

		local prefix_reverse = fun.compose(prefix2, prefix1)
		result = prefix_reverse("hello")
		assert_equal(result, "_$hello")
	end

	function test.map()
		local items    = {2, 10, 100, 50, 1, -50, 0.5}
		local expected = {4, 20, 200, 100, 2, -100, 1}
		local double = function(a) return a * 2 end
		local result = fun.map(items, double)
		assert_table_equal(result, expected)
	end

	function test.filter()
		local items    = {10, 11, 12, 13, 14, 15, 16}
		local expected = {10, 12, 14, 16}
		local even = function(a) return a % 2 == 0 end
		local result = fun.filter(items, even)
		assert_table_equal(result, expected)
	end

	function test.reduce()
		local items = {5000, 2, 30, 400}
		local sum = function(last, next, index, t) return last + next end
		local result = fun.reduce(items, sum)
		assert_equal(result, 5432)

		result = fun.reduce(items, sum, 1)
		assert_equal(result, 5433)
	end

	function test.aggregate()
		local items = {"one", "two", "three"}
		local stringsum = function(a, b) return a + #b end
		local result = fun.aggregate(items, stringsum, 0)
		assert_equal(result, 11)

		local numbers = {2,3,4,1,8,7,9,3}
		local min = fun.aggregate(numbers, math.min)
		assert_equal(min, 1)
	end

	function test.every()
		local over50items = {51, 52, 99, 65, 78}
		local over20items = {51, 24, 99, 46, 78}
		local isOver50 = function(a) return a > 50 end
		local result = fun.every(over50items, isOver50)
		assert_equal(result, true)

		result = fun.every(over20items, isOver50)
		assert_equal(result, false)
	end

	function test.any()
		local over50items = {51, 52, 99, 65, 78}
		local over20items = {51, 24, 99, 46, 78}
		local isOver50 = function(a) return a > 50 end
		local result = fun.any(over50items, isOver50)
		assert_equal(result, true)

		result = fun.any(over20items, isOver50)
		assert_equal(result, true)
	end

	function test.apply()
		local names = {"bob", "Phil", "jAmes", "joNES", "sophie"}
		local expected = {"BOB", "PHIL", "JAMES", "JONES", "SOPHIE"}
		local upperAll = fun.apply(string.upper)
		local upperNames = upperAll(names)
		assert_table_equal(upperNames, expected)
	end

	function test.best()
		local items = {45, 28, 33, 32, 11, 93, 10, 5, 78}
		local expected = 93
		local biggest = function(a, b) return a > b end
		local best = fun.best(items, biggest)
		assert_equal(best, expected)

		local closest = function(a, b) return math.abs(a) < math.abs(b) end
		local points = {-100, -56, -24, 25, 66, 932}
		best = fun.best(points, closest)
		assert_equal(best, -24)
	end

	function test.pluck()
		local items = {
			{
				firstname = "James",
				lastname  = "Greives",
				age = 42
			},
			{
				firstname = "Charlie",
				lastname  = "Brown",
				age = 15
			},
			{
				firstname = "Sophie",
				lastname  = "Corner",
				age = 71
			}
		}
		local expected = {42, 15, 71}
		local ages = fun.pluck(items, "age")
		assert_table_equal(ages, expected)
	end

	function test.shuffle()
		local items = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,foo = "bar",baz = "noop"}
		local result = fun.shuffle(items)
		assert_table_not_equal(result, items)
	end

	function test.chaining()
		local items = {10, "foo", 8, 5, 9, 100, "baz", -15}
		local expected = {20, 10, 200, -30}
		local filter_numbers = function(a) return type(a) == "number" end
		local factor5 = function(a) return a % 5 == 0 end
		local double = function(a) return a * 2 end
		local result = fun(items):filter(filter_numbers):filter(factor5):map(double)
		assert_table_equal(result, expected)
	end

	function test.bind_chaining()
		local items = {10, "foo", 8, 5, 9, 100, "baz", -15}
		local expected = {20, 10, 200, -30}

		fun.bind("filter_numbers", fun.filter, function(a) return type(a) == "number" end)
		fun.bind("filter_factor5", fun.filter, function(a) return a % 5 == 0 end)
		fun.bind("double", fun.map, function(a) return a * 2 end)

		local result = fun(items):filter_numbers():filter_factor5():double()
		assert_table_equal(result, expected)

		fun.bind("map", fun.map, function(a) error("Oops, I have overwritted the map function") end)
		fun.map(items, fun.noop)
	end

	function test.select_while()
		local items = {1,2,3,4,5,6,7,8,9}
		local expected = {1,2,3,4}
		local result = fun.select_while(items, fun.lt(5))
		assert_table_equal(result, expected)
	end

	function test.select_until()
		local items = {1,2,3,4,5,6,7,8,9}
		local expected = {1,2,3,4,5,6}
		local result = fun.select_until(items, fun.gte(7))
		assert_table_equal(result, expected)
	end

	function test.first()
		local items = {4,5,6,7,8,9}
		local result = fun.first(items)
		assert_equal(result, 4)
	end

	function test.last()
		local items = {4,5,6,7,8,9,"foo"}
		local result = fun.last(items)
		assert_equal(result, "foo")
	end

	function test.zip()
		local left = {1,2,3,4}
		local right = {"a", "b", "c", "d"}
		local result = fun.zip(left, right)
		assert_table_equal(result[1], {1, "a"})
		assert_table_equal(result[2], {2, "b"})
	end

	function test.zip_flat()
		local left = {1,2,3,4}
		local right = {"a", "b", "c", "d"}
		local result = fun.zip_flat(left, right)
		assert_table_equal(result, {1, "a", 2, "b", 3, "c", 4, "d"})
	end

	function test.zip_with()
		local left = {1,2,3,4}
		local right = {"a", "b", "c", "d"}
		local concat = function(a, b) return b..a end
		local result = fun.zip_with(left, right, concat)
		assert_table_equal(result, {"a1", "b2", "c3", "d4"})
	end

	function test.difference()
		local left = {1,2,3,4,5,6}
		local right = {2,5,6,10}
		local result = fun.difference(left, right)
		assert_table_equal(result, {1,3,4,10})
	end

	function test.intersect()
		local left = {1,2,3,4,5,6}
		local right = {2,5,6,10}
		local result = fun.intersect(left, right)
		assert_table_equal(result, {2,5,6})
	end

	function test.eq()
		local a, b, c = 5, 5, 2
		local equals5 = fun.eq(5)
		assert_equal(equals5(a), equals5(b), "equals5")

		local foo = {id = 2933}
		local bar = {id = 7099}
		local correctID = fun.eq(2933, 'id')
		assert_equal(correctID(foo), true, "correctID")
	end

	function test.sum()
		local items = {50, 100, 1}
		local result = fun.sum(items)
		assert_equal(result, 151)

		local names = {"one", "two", "three"}
		local charactercount = fun.sum(names, fun.len)
		assert_equal(charactercount, 11)
	end

	function test.complex()
		local videos = {
			{
				id = 70111470,
				title = "Die Hard",
				boxart =  "http://cdn-0.nflximg.com/images/2891/DieHard.jpg",
				uri = "http://api.netflix.com/catalog/titles/movies/70111470",
				rating = 5.0,
				bookmark = {}
			},
			{
				id = 654356453,
				title = "Bad Boys",
				boxart = "http://cdn-0.nflximg.com/images/2891/BadBoys.jpg",
				uri = "http://api.netflix.com/catalog/titles/movies/70111470",
				rating = 4.0,
				bookmark = { id = 432534, time = 65876586 }
			},
			{
				id = 65432445,
				title = "The Chamber",
				boxart = "http://cdn-0.nflximg.com/images/2891/TheChamber.jpg",
				uri = "http://api.netflix.com/catalog/titles/movies/70111470",
				rating = 5.0,
				bookmark = { id = 432534, time = 65876586 }
			}
		}
		local comments = {
			{id = 100, videoid = 65432445, comment = "Good movie, would reccomend."},
			{id = 101, videoid = 65432445, comment = "Meh."}
		}
		-- Get id and comments of all videos where ratings is 5 or more
		-- end result would be:
		-- { {id = 70111470, comments = {}}, {id = 65432445, comments = {"c1", "c2"}} }

		-- local result = fun(videos)
		-- 	:filter(function(a) return a.rating >= 5 end)
		-- 	:pluck("id")
		-- 	:map(function(id)
		-- 		local vcomments = fun.filter(comments, function(a) return a.videoid == id end):pluck("comment")
		-- 		return {['id'] = id, ['comments'] = vcomments}
		-- 	end)

		local add_comments = function(v_id)
			local v_comments = fun.filter(comments, fun.eq(v_id, 'videoid')):pluck('comment')
			return {id = v_id, comments = v_comments}
		end
		local result = fun(videos)
			:filter(fun.gte(5, 'rating'))
			:pluck('id')
			:map(add_comments)

		assert_equal(result[1].id, 70111470)
		assert_equal(result[2].id, 65432445)
		assert_table_equal(result[1].comments, {})
		assert_table_equal(result[2].comments, {"Good movie, would reccomend.", "Meh."})
	end

	function _do_test( fn, k )
		local r, err = pcall(fn)
		local out = r and {"Passed:", k} or {"FAILED:", k, err}
		print(unpack(out))
		return r
	end

	function _test_all()
		local passed = 0
		local count = 0
		for k, fn in pairs(test) do
			if _do_test(fn, k) then passed = passed + 1 end
			count = count + 1
		end
		print(string.format("%i / %i tests passed.", passed, count))
	end

	function _test_specific( name )
		if test[name] then
			_do_test(test[name], name)
		else
			error("Test with name "..name.." does not exist.")
		end
	end

	return {
		["all"] = _test_all,
		["test"] = _test_specific
	}
end

-- unit_tests().all()