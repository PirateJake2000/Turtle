repo = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/_Files.lua"

function download(name, url)
  print("Updating " .. name)
 
  request = http.get(url)
  data = request.readAll()
 
  if fs.exists(name) then
    fs.delete(name)
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  else
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  end
 
  print("Successfully downloaded " .. name .. "\n")
end

-- Start by downloading the repo file
download("_Files.lua", repo)

-- Read the repo file for a list of files to download
local file = fs.open("_Files.lua", "r")
local data = file.readAll()

-- Load the file into a table
local files = textutils.unserialize(data)
file.close()

-- Download each file
for i, file in ipairs(files) do
  download(file, "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/" .. file .. ".lua")
end

term.clear()
term.setCursorPos()