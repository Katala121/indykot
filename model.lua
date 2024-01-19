local view = require 'view';

letters = { 'A', 'B', 'C', 'D', 'E', 'F' };

local model = {
  matrix = {}
};

function model:init()
  function checkNext()
    local result = false;
    local list = {};
    for i=0, 9 do
      for j=0, 9 do
        if j ~= 0 and j ~= 9 and self.matrix[i][j] == self.matrix[i][j - 1] then
          table.insert(list, 1, { x1 = i, y1 = j, x2 = i, y2 = j - 1 });
        elseif i ~= 0 and i ~= 9 and self.matrix[i][j] == self.matrix[i - 1][j] then
          table.insert(list, 1, { x1 = i, y1 = j, x2 = i - 1, y2 = j });
        end
      end
    end
    for i=1, #list do
      if list[i]['x1'] == list[i]['x2'] then
        if list[i]['y1'] < 8 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1']][list[i]['y1'] + 2] then
          result = true;
          print(list[i]['x1'], list[i]['y1'], list[i]['x1'], list[i]['y1'] + 2)
          break;
        elseif list[i]['x1'] ~= 0 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] - 1][list[i]['y1'] + 1] then
          result = true;
          print(list[i]['x1'], list[i]['y1'], list[i]['x1'] - 1, list[i]['y1'] + 1)
          break;
        elseif list[i]['x1'] ~= 9 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] + 1] then
          result = true;
          print(list[i]['x1'], list[i]['y1'], list[i]['x1'] + 1, list[i]['y1'] + 1)
          break;
        end
      else

      end
    end
  end;


  self:mix();
  self:dump();
  checkNext();
  while true do
    local input = io.read();
    if input == 'q' then break;
    elseif string.sub(input,1,1) == 'm' then
    local x = string.sub(input,2,2);
    local y = string.sub(input,3,3);
      if string.sub(input,4,4) == 'l' and y ~= '0' then self:move(string.sub(input,2,3), x .. math.floor(y - 1));
      elseif string.sub(input,4,4) == 'r' and y ~= '9' then self:move(string.sub(input,2,3), x .. math.floor(y + 1));
      elseif string.sub(input,4,4) == 'u' and x ~= '0' then self:move(string.sub(input,2,3), math.floor(x - 1) .. y);
      elseif string.sub(input,4,4) == 'd' and x ~= '9' then self:move(string.sub(input,2,3), math.floor(x + 1) .. y);
      end;
    end;
    self:dump();
    self:tick();
  end
end

function model:dump()
  if not os.execute("cls") then os.execute("clear") end;
  if not os.execute("clear") then os.execute("cls") end;
  view.printHeader();
  for i=0, 9 do
    view.printRow(i, self.matrix[i]);
  end
end

function model:tick()
  function check()
    local list = {};
    for i=0, 9 do
      for j=0, 9 do
        if j ~= 0 and j ~= 9 and self.matrix[i][j] == self.matrix[i][j - 1] and self.matrix[i][j] == self.matrix[i][j + 1] then
          list[1] = { x = i, y = j - 1 };
          list[2] = { x = i , y = j };
          list[3] = {x = i, y = j + 1};
          if j > 1 and self.matrix[i][j] == self.matrix[i][j - 2] then
            table.insert(list, 1, { x = i, y = j - 2 });
            if j > 2 and self.matrix[i][j] == self.matrix[i][j - 3] then table.insert(list, 1, { x = i, y = j - 3 }); end;
          end;
        elseif i ~= 0 and i ~= 9 and self.matrix[i][j] == self.matrix[i - 1][j] and self.matrix[i][j] == self.matrix[i + 1][j] then
          list[1] = { x = i - 1, y = j };
          list[2] = { x = i , y = j };
          list[3] = { x = i + 1, y = j };
          if i > 1 and self.matrix[i][j] == self.matrix[i - 2][j] then
            table.insert(list, 1, { x = i - 2, y = j });
            if i > 2 and self.matrix[i][j] == self.matrix[i - 3][j] then table.insert(list, 1, { x = i - 3, y = j }); end;
          end;
        end
      end
    end
    return list;
  end;

  function checkNext()
    local list = {};
    for i=0, 9 do
      for j=0, 9 do
        if j ~= 0 and j ~= 9 and self.matrix[i][j] == self.matrix[i][j - 1] then
          table.insert(list, 1, { x1 = i, y1 = j, x2 = i, y2 = j - 1 });
          print(i, j, i, j - 1);
        elseif i ~= 0 and i ~= 9 and self.matrix[i][j] == self.matrix[i - 1][j] then
          table.insert(list, 1, { x1 = i, y1 = j, x2 = i - 1, y2 = j });
          print(i, j, i - 1, j);
        end
      end
    end

  end;

  function burn(self, coords)
    for i=1, #coords do
      print(coords[i]['x'], coords[i]['y']);
      self.matrix[tonumber(coords[i]['x'])][tonumber(coords[i]['y'])] = '*';
    end
    self:dump();
  end

  function shift(self, coords)
    if coords[1]['x'] == coords[2]['x'] then
      for i=0, #coords - 1 do
        for j=coords[i + 1]['x'], 0, -1 do
          if j == 0 then self.matrix[j][coords[i + 1]['y']] = letters[math.random(1,6)];
          else
            self.matrix[j][coords[i + 1]['y']] = self.matrix[j - 1][coords[i + 1]['y']];
          end
        end
        self:dump();
        wait();
      end
    else
      local lastX = coords[#coords]['x'];
      for i=0, #coords - 1 do
        for j=lastX, 0, -1 do
          if j == 0 then self.matrix[j][coords[i + 1]['y']] = letters[math.random(1,6)];
          else
            self.matrix[j][coords[i + 1]['y']] = self.matrix[j - 1][coords[i + 1]['y']];
          end
        end
        self:dump();
        wait();
      end
    end
  end

  function wait()
    os.execute("sleep " .. tonumber(1))
  end

  local match = check();
  if match[1] then
   burn(self, match);
   wait();
   shift(self, match);
   wait();
   self:tick();
   wait();
  end;
end

function model:move(from, to)
  local fromX = tonumber(string.sub(from,1,1));
  local fromY = tonumber(string.sub(from,2,2));
  local toX = tonumber(string.sub(to,1,1));
  local toY = tonumber(string.sub(to,2,2));
  local tmp = self.matrix[toX][toY];
  self.matrix[toX][toY] = self.matrix[fromX][fromY];
  self.matrix[fromX][fromY] = tmp;
end

function model:mix()
  for i=0, 9 do
      self.matrix[i] = {};
      for j=0, 9 do
        self.matrix[i][j] = letters[math.random(1,6)];
      end
    end
end

model:init();
