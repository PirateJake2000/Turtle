repo = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/_Files.txt"
path = "https://raw.githubusercontent.com/PirateJake2000/Turtle/main/"

term.clear()
term.setCursorPos()

function download(name, url)
  request = http.get(url)

  if request == nil then
    print("Failed to download: " .. name)
    return
  end

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

