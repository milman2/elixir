# IO and the file system
- IO
- File
- Path

# File
- IO.binread
- IO.binwrite
- File.read
- File.close
```elixir
{:ok, file} = File.open("path/to/file/hello", [:write])
IO.binwrite(file, "world")
File.close(file)
File.read("path/to/file/hello")
```
- File.rm
- File.mkdir
- File.mkdir_p
- File.cp_r
- File.rm_rf

# Path
- Path.join
- Path.expand

# Process

# iodata and chardata
