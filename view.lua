local View = {};

function View.print(self, matrix)
  self.printHeader(matrix[0]);
  for i=0, #matrix do
    local temp = "";
      for j=0, #matrix[i] do
        temp = temp .. ' ' .. matrix[i][j];
      end
      print(i .. ' | ' .. temp);
  end
end

function View.printHeader(row)
  local temp = "";
  for i=0, #row do
    temp = temp .. ' ' .. i;
  end
  print(' ' .. '   ' .. temp);
  print('     _ _ _ _ _ _ _ _ _ _');
end

return View;