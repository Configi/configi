package.path="vendor/lua/?.lua"
local lib = require "lib"
local file = lib.file
local util = lib.util
local random = util.random_string
local T = require "u-test"
local exec = require"exec"
T["exec.context"] = function()
  local s = random(12)
  local touch = exec.ctx"touch"
  touch(s)
  T.equal(true, file.test(s))
  os.execute("rm " .. s)
end
T["exec.context cwd"] = function()
  local s = random(12)
  local touch = exec.ctx"touch"
  touch.cwd = "/tmp"
  touch(s)
  T.equal(true, file.test("/tmp/"..s))
  os.execute("rm /tmp/" .. s)
end
T["exec.cmd"] = function()
  local s = random(12)
  local cmd = exec.cmd
  cmd.touch(s)
  T.equal(true, file.test(s))
  os.execute("rm " .. s)
end
T["exec.spawn stdout"] = function()
  local echo = exec.ctx"echo"
  local cmd = exec.cmd
  local a, b, _
  _, a = cmd.echo("-n", "-e", [[aaa\nbbb]])
  _, b = echo("-n", "-e", [[aaa\nbbb]])
  T.equal(a["stdout"][1], "aaa")
  T.equal(a["stdout"][2], "bbb")
  T.equal(b["stdout"][1], "aaa")
  T.equal(b["stdout"][2], "bbb")
end
T["exec.spawn stderr"] = function()
  local ls = exec.ctx"ls"
  local cmd = exec.cmd
  local a, b
  x, a = ls("sdfsdf")
  y, b = cmd.ls("sdfsdf")
  T.is_nil(x)
  T.is_nil(y)
  T.equal(a["stderr"][1], "ls: cannot access 'sdfsdf': No such file or directory")
  T.equal(b["stderr"][1], "ls: cannot access 'sdfsdf': No such file or directory")
end
T["exec.spawn stdin"] = function()
  local sed = exec.ctx"sed"
  sed.stdin = "xxxabcyyy"
  local _, a
  _, a = sed("s:abc:123:g")
  T.equal(a["stdout"][1], "xxx123yyy")
end
T["exec.spawn stdout redirect"] = function()
  local s = random(12)
  local ls = exec.ctx"ls"
  ls.stdout = s
  local a, _
  ls"/etc/passwd"
  T.equal("/etc/passwd\n", file.read_all(s))
  os.execute("rm " .. s)
end
T["exec.spawn stderr redirect"] = function()
  local s = random(12)
  local ls = exec.ctx"ls"
  ls.stderr = s
  local a, b
  a, b = ls"non-existent"
  T.is_nil(a)
  T.is_nil(b["stderr"][1])
  T.equal("ls: cannot access 'non-existent': No such file or directory\n", file.read_all(s))
  os.execute("rm " .. s)
end
T["exec.spawn ignore"] = function()
  local ls = exec.ctx"ls"
  ls.ignore = true
  local a, b = ls"non-existent"
  T.not_equal(0, b.code)
  T.equal(type(a), "number")
  T.equal(b["stderr"][1], "ls: cannot access 'non-existent': No such file or directory")
end
T["exec.spawn cwd"] = function()
  local ls = exec.ctx"ls"
  local a, b
  ls.cwd = "/etc"
  a, b = ls"passwd"
  T.equal(type(a), "number")
  T.equal(b["stdout"][1], "passwd")
end
T["exec.spawn env"] = function()
  local env = exec.ctx"/usr/bin/env"
  local a, b
  env.env = { TXT = "yo" }
  a, b = env""
  local stdout = b.stdout
  T.equal(stdout[#stdout], "TXT=yo")
end
T.summary()
