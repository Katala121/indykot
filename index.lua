local view = require 'view';

letters = { 'A', 'B', 'C', 'D', 'E', 'F' };

local model = {
  matrix = {}
};

function model:init()
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
  end
end

function model:dump()
  os.execute("clear");
  view.printHeader();
  for i=0, 9 do
    view.print(i, self.matrix[i + 1]);
  end
end

function model:tick()
  function check()
    local list = {};
    for i=1, 10 do
      for j=1, 10 do
        if j ~= 1 and j ~= 10 and self.matrix[i][j] == self.matrix[i][j - 1] and self.matrix[i][j] == self.matrix[i][j + 1] then
          list[1] = { x = i, y = j - 1 };
          list[2] = { x = i , y = j };
          list[3] = {x = i, y = j + 1};
        elseif i ~= 1 and i ~= 10 and self.matrix[i][j] == self.matrix[i - 1][j] and self.matrix[i][j] == self.matrix[i + 1][j] then
          list[1] = { x = i - 1, y = j };
          list[2] = { x = i , y = j };
          list[3] = { x = i + 1, y = j };
        end
      end
    end
    return list;
  end;

  function burn(self, coords)
    for i=1, #coords do
      self.matrix[tonumber(coords[i]['x'])][tonumber(coords[i]['y'])] = '*';
    end
    self:dump();
  end

  function shift(self, coords)
    if coords[1]['x'] == coords[2]['x'] then
      for i=1, #coords do
        for j=coords[i]['x'], 1, -1 do
          if j == 1 then self.matrix[j][coords[i]['y']] = letters[math.random(1,6)];
          else
            self.matrix[j][coords[i]['y']] = self.matrix[j - 1][coords[i]['y']];
          end
        end
        self:dump();
        wait();
      end
    else
      local lastX = coords[#coords]['x'];
      for i=1, #coords do
        for j=lastX, 1, -1 do
          if j == 1 then self.matrix[j][coords[i]['y']] = letters[math.random(1,6)];
          else
            self.matrix[j][coords[i]['y']] = self.matrix[j - 1][coords[i]['y']];
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
  local fromX = tonumber(string.sub(from,1,1)) + 1;
  local fromY = tonumber(string.sub(from,2,2)) + 1;
  local toX = tonumber(string.sub(to,1,1)) + 1;
  local toY = tonumber(string.sub(to,2,2)) + 1;
  local tmp = self.matrix[toX][toY];
  self.matrix[toX][toY] = self.matrix[fromX][fromY];
  self.matrix[fromX][fromY] = tmp;
end

function model:mix()
  for i=1, 10 do
      self.matrix[i] = {};
      for j=1, 10 do
        self.matrix[i][j] = letters[math.random(1,6)];
      end
    end
end

model:init();
