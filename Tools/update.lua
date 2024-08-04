repo = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/_Files.txt"

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
download("_Files.txt", repo)

-- Read the repo file for a list of files to download
local file = fs.open("_Files.txt", "r")
local data = file.readAll()

-- Load the file into a table
local files = textutils.unserialize(data)
file.close()

-- Delete the repo file
fs.delete("_Files.txt")

-- print list of files
print("Files to download:")
for i, file in ipairs(files) do
  print(file)
end

term.clear()
term.setCursorPos()