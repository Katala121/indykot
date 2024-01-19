local View = {};

function View.printRow(index, array)
  local temp = "";
  for i=0, 9 do
    temp = temp .. ' ' .. array[i];
  end
  print(index .. ' | ' .. temp);
end

function View.printHeader()
  local temp = "";
  for i=0, 9 do
    temp = temp .. ' ' .. i;
  end
  print(' ' .. '   ' .. temp);
  print('     _ _ _ _ _ _ _ _ _ _');
end

return View;