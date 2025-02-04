-- Define the calculator GUI
local calculator_formspec = "size[8.5,9.5]" ..
  "label[0.5,0;2BW Instruments        TI-1250]" ..
  "textarea[0.5,0.5;8,1;output;;${result}]" ..
  "box[0.4,1.4;4.5,5.5;#8A2BE2]" ..
  "button[0.5,1.5;1.5,1;btn_1;1]" ..
  "button[2,1.5;1.5,1;btn_2;2]" ..
  "button[3.5,1.5;1.5,1;btn_3;3]" ..
  "button[0.5,3;1.5,1;btn_4;4]" ..
  "button[2,3;1.5,1;btn_5;5]" ..
  "button[3.5,3;1.5,1;btn_6;6]" ..
  "button[0.5,4.5;1.5,1;btn_7;7]" ..
  "button[2,4.5;1.5,1;btn_8;8]" ..
  "button[3.5,4.5;1.5,1;btn_9;9]" ..
  "button[2,6;1.5,1;btn_0;0]" ..
  "button[3.5,6;1.5,1;btn_dot;.]" ..
  "box[6.4,5.9;1.5,1;#ff0000]" ..
  "button[6.5,6;1.5,1;btn_eq;=]" ..
  "button[5,4.5;1.5,1;btn_sub;-]" ..
  "button[6.5,4.5;1.5,1;btn_mul;*]" ..
  "button[5,3;1.5,1;btn_div;/]" ..
  "button[6.5,3;1.5,1;btn_add;+]" ..
  "button[5,1.5;1.5,1;btn_clear;C]" ..
  "button[0.5,6;1.5,1;btn_op;+-]" ..
  "button[0.5,7.5;1.5,1;btn_copy;Copy]" ..
  "button[2,7.5;1.5,1;btn_paste;Paste]" ..
  "button[3.5,7.5;1.5,1;btn_pi;π]" ..
  "button[2,9;1.5,1;btn_qat;x^2]" ..
  "button[0.5,9;1.5,1;btn_sqrt;√]" ..
  -- "button[5,6;1.5,1;btn_ans;ANS]" ..
  "button[6.5,1.5;1.5,1;btn_del;DEL]" ..
  "button[6.5,9;1.5,1;btn_exit;EXIT]"

-- Track user input
local first_number = ""
local second_number = ""
local operator = ""
local copied_expression = ""

-- Register the calculator GUI
minetest.register_on_player_receive_fields(function(player, formname, fields)
  if formname == "calculator" then
    local expression = fields.output or ""

    -- Handle button clicks
    if fields.btn_1 then expression = expression .. "1" end
    if fields.btn_2 then expression = expression .. "2" end
    if fields.btn_3 then expression = expression .. "3" end
    if fields.btn_4 then expression = expression .. "4" end
    if fields.btn_5 then expression = expression .. "5" end
    if fields.btn_6 then expression = expression .. "6" end
    if fields.btn_7 then expression = expression .. "7" end
    if fields.btn_8 then expression = expression .. "8" end
    if fields.btn_9 then expression = expression .. "9" end
    if fields.btn_0 then expression = expression .. "0" end
    if fields.btn_dot then expression = expression .. "." end
    if fields.btn_add then
      first_number = expression
      operator = "+"
      expression = ""
    end

    if fields.btn_op then
      if expression then
        local expressionValue = tonumber(expression)
        if expressionValue ~= nil then
          expression = expressionValue * -1
        else
          expression = "Error: expression not valid number"
        end
      else 
        expression = "Error: expression is nil"
      end
    end

    if fields.btn_sub then
      first_number = expression
      operator = "-"
      expression = ""
    end

    if fields.btn_mul then
      first_number = expression
      operator = "*"
      expression = ""
    end

    if fields.btn_div then
      first_number = expression
      operator = "/"
      expression = ""
    end

    if fields.btn_clear then
      first_number = ""
      second_number = ""
      operator = ""
      expression = ""
    end

    if fields.btn_del then
      expression = expression:sub(1, -2)
    end

    if fields.btn_copy then
      check_expression = tonumber(expression)
      if check_expression ~= nil then
        copied_expression = check_expression
      end
    end

    if fields.btn_paste then
      if copied_expression then
        expression = expression .. copied_expression
      end
    end

    if fields.btn_pi then
      expression = expression .. "3.1415"
    end

    if fields.btn_qat then
      expressionValue = tonumber(expression)
      if expressionValue ~= nil then
        expression = expressionValue * expressionValue
      end
    end

    if fields.btn_sqrt then
      expressionValue = tonumber(expression)
      if expressionValue ~= nil then
        expression = math.sqrt(expressionValue)
      end
    end

    if fields.btn_eq then
      local first_numberValue = tonumber(first_number)
      if first_numberValue ~= nil then
        if expression then
          local expressionValue = tonumber(expression)
          if expressionValue ~= nil then
            second_number = expressionValue
          else 
            expression = "expression is not a valid number"
          end
        end

        local result = perform_calculation(first_number, operator, second_number)
        expression = tostring(result)
        first_number = expression
        second_number = ""
        operator = ""
      else
        expression = "Error: first_number is not a valid number"
      end
    end

    if fields.btn_exit then
      minetest.show_formspec(player:get_player_name(), "", "")
      return true
    end

    -- Update the formspec with the modified expression
    minetest.show_formspec(player:get_player_name(), "calculator", calculator_formspec:gsub("${result}", expression))
  end
end)

-- Perform calculation based on operator
function perform_calculation(first, op, second)
  if op == "+" then
    return tonumber(first) + tonumber(second)
  elseif op == "-" then
    return tonumber(first) - tonumber(second)
  elseif op == "*" then
    return tonumber(first) * tonumber(second)
  elseif op == "/" then
    if tonumber(second) ~= 0 then
      return tonumber(first) / tonumber(second)
    else
      return "Error: Division by zero"
    end
  else
    return "Error: Invalid operator"
  end
end

-- Open the calculator GUI when the player types "/calculator" in the chat
minetest.register_chatcommand("bwcalc", {
  params = "",
  description = "Open the calculator GUI",
  func = function(name, param)
    minetest.show_formspec(name, "calculator", calculator_formspec:gsub("${result}", ""))
  end,
})