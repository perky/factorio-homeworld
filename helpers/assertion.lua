local ENABLED = true
assertion = {}

function assertion.not_nil(value, message)
    assert(value, message)
end

function assertion.is_nil(value, message)
    assert(value == nil, message)
end

function assertion.is_true(expression, message)
    assert(expression == true, message)
end

function assertion.is_false(expression, message)
    assert(expression == false, message)
end

function assertion.is_equal(expected, value, message)
    if (expected ~= value) then
        error("Expected "..expected..", got "..value.." : "..(message or ""))
        return false
    end
    return true
end

if not ENABLED then
    for name, func in pairs(assertion) do
        assertion[name] = function(...) return true end
    end
end