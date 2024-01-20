local view = require 'view';

letters = { 'A', 'B', 'C', 'D', 'E', 'F' };
stepSpeed = 0.5;

local model = {
  matrix = {},
  isOsUnix = true
};

function model:checkNext()
  local result = false;
  local list = {};
  for i=0, 9 do
    for j=0, 9 do
      if j ~= 0 and j ~= 9 and self.matrix[i][j] == self.matrix[i][j - 1] then
        table.insert(list, 1, { x1 = i, y1 = j, x2 = i, y2 = j - 1 });
      elseif i ~= 0 and i ~= 9 and self.matrix[i][j] == self.matrix[i - 1][j] then
        table.insert(list, 1, { x1 = i, y1 = j, x2 = i - 1, y2 = j });
      elseif j < 8 and self.matrix[i][j] == self.matrix[i][j + 2] then
        table.insert(list, 1, { x1 = i, y1 = j, x2 = i, y2 = j + 2 });
      elseif i < 8 and self.matrix[i][j] == self.matrix[i + 2][j] then
        table.insert(list, 1, { x1 = i, y1 = j, x2 = i + 2, y2 = j });
      end
    end
  end
  for i=1, #list do
    if list[i]['x1'] == list[i]['x2'] and list[i]['y1'] - list[i]['y2'] == 1 then
      if list[i]['y1'] < 8 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1']][list[i]['y1'] + 2] then
        result = true;
        break;
      elseif list[i]['x1'] ~= 0 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] - 1][list[i]['y1'] + 1] then
        result = true;
        break;
      elseif list[i]['x1'] ~= 9 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] + 1] then
        result = true;
        break;
      elseif list[i]['y2'] > 1 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2']][list[i]['y2'] - 2] then
        result = true;
        break;
      elseif list[i]['x2'] ~= 0 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2'] - 1][list[i]['y2'] - 1] then
        result = true;
        break;
      elseif list[i]['x2'] ~= 9 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2'] + 1][list[i]['y2'] - 1] then
        result = true;
        break;
      end
    elseif list[i]['y1'] == list[i]['y2'] and list[i]['x1'] - list[i]['x2'] == 1 then
      if list[i]['x1'] < 8 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 2][list[i]['y1']] then
        result = true;
        break;
      elseif list[i]['y1'] ~= 0 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] - 1] then
        result = true;
        break;
      elseif list[i]['y1'] ~= 9 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] + 1] then
        result = true;
        break;
      elseif list[i]['x2'] > 1 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2'] - 2][list[i]['y2']] then
        result = true;
        break;
      elseif list[i]['y2'] ~= 0 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2'] - 1][list[i]['y2'] - 1] then
        result = true;
        break;
      elseif list[i]['y2'] ~= 9 and self.matrix[list[i]['x2']][list[i]['y2']] == self.matrix[list[i]['x2'] - 1][list[i]['y2'] + 1] then
        result = true;
        break;
      end
    elseif list[i]['x1'] == list[i]['x2'] and list[i]['y2'] - list[i]['y1'] == 2 then
      if list[i]['x1'] ~= 0 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] - 1][list[i]['y1'] + 1] then
        result = true;
        break;
      elseif list[i]['x1'] ~= 9 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] + 1] then
        result = true;
        break;
      end
    elseif list[i]['y1'] == list[i]['y2'] and list[i]['x2'] - list[i]['x1'] == 2 then
      if list[i]['y1'] ~= 0 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] - 1] then
        result = true;
        break;
      elseif list[i]['y1'] ~= 9 and self.matrix[list[i]['x1']][list[i]['y1']] == self.matrix[list[i]['x1'] + 1][list[i]['y1'] + 1] then
        result = true;
        break;
      end
    end
  end
  return result;
end;

function model:init()
  if not os.execute("clear") then self.isOsUnix = false end;
  self:mix();
  self:dump();
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
    local isExistNextStep = self:checkNext();
    if not isExistNextStep then
      self:mix();
      self:dump();
    end;
  end
end

function model:dump()
  if self.isOsUnix then os.execute("clear")
  else os.execute("cls") end;
  view:print(self.matrix);
end

function model:checkMatching()
  local list = {};
  for i=0, 9 do
    for j=0, 9 do
      if j ~= 0 and j ~= 9 and self.matrix[i][j] == self.matrix[i][j - 1] and self.matrix[i][j] == self.matrix[i][j + 1] then
        list = {};
        list[1] = { x = i, y = j - 1 };
        list[2] = { x = i , y = j };
        list[3] = {x = i, y = j + 1};
        if j > 1 and self.matrix[i][j] == self.matrix[i][j - 2] then
          table.insert(list, 1, { x = i, y = j - 2 });
          if j > 2 and self.matrix[i][j] == self.matrix[i][j - 3] then table.insert(list, 1, { x = i, y = j - 3 }); end;
        end;
      elseif i ~= 0 and i ~= 9 and self.matrix[i][j] == self.matrix[i - 1][j] and self.matrix[i][j] == self.matrix[i + 1][j] then
        list = {};
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

function model:tick()

  function burn(self, coords)
    for i=1, #coords do
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
    os.execute("sleep " .. tonumber(stepSpeed));
  end

  local match = self:checkMatching();
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
  local match = self:checkMatching();
  if match[1] then self:mix() end;
end

model:init();
