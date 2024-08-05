repo = "_Files.txt"
path = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/"

function download(name)
  request = http.get(path..name)

  if request == nil then
    print("Failed to download: " .. name)
    return
  end

  data = request.readAll()

  local updatedFile = false
 
  if fs.exists(name) then
    -- Compare the file to see if it needs updating if it does update it
    local file = fs.open(name, "r")
    local oldData = file.readAll()
    file.close()

    if oldData ~= data then
      updatedFile = true
    end

  end
  
  if updatedFile then
    print("Updating " .. name)
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  else
    print("No changes to " .. name)
  end


  return updatedFile
end
-- Start by downloading the repo file
download("_Files.txt", repo)

-- Read the repo file for a list of files to download
local file = fs.open("_Files.txt", "r")
local fileList = textutils.unserialize(file.readAll())
file.close()

for i, v in pairs(fileList) do
  print("Downloading \n" ..path..v)
  download(v)
end

-- Clean up
fs.delete("_Files.txt")

term.clear()
term.setCursorPos(1,1)
print("Updated Turtle")
