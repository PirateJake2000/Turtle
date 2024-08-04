repo = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/_Files.txt"
path = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/"

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
local fileList = textutils.unserialize(file.readAll())
file.close()

for i, v in pairs(fileList) do
  print("Downloading " .. v)
  download(i, path..v)
end

print("Update complete")
print("Updated: " .. #fileList .. " files")

term.clear()
term.setCursorPos()



