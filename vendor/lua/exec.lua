local ffi = require "ffi"
local C = ffi.C
local exec = {}

ffi.cdef([[
static const int EINTR = 4; /* Interrupted system call */
static const int EAGAIN = 11; /* Try again */
typedef int32_t pid_t;
pid_t fork(void);
pid_t waitpid(pid_t pid, int *status, int options);
char *strerror(int errnum);
int open(const char *pathname, int flags, int mode);
int close(int fd);
int dup2(int oldfd, int newfd);
int setenv(const char*, const char*, int);
int execvp(const char *file, char *const argv[]);
int chdir(const char *);
]])
local strerror = function(s)
  s = s or "error"
  return string.format("%s: %s\n", s, ffi.string(C.strerror(ffi.errno())))
end
local octal = function(n) return tonumber(n, 8) end
local STDOUT = 1
local STDERR = 2
local ERETRY = function(fn)
  return function(...)
    local r, e
    repeat
      r = fn(...)
      e = ffi.errno()
      if r ~= -1 then
        break
      end
    until((e ~= C.EINTR) and (e ~= C.EAGAIN))
    return r, e
  end
end

-- dest should be either 0 or 1 (STDOUT or STDERR)
local redirect = function(io_or_filename, dest_fd)
  if io_or_filename == nil then return true end
  local O_WRONLY = octal('0001')
  local O_CREAT  = octal('0100')
  local S_IRUSR  = octal('00400') -- user has read permission
  local S_IWUSR  = octal('00200') -- user has write permission
  -- first check for regular
  if (io_or_filename == io.stdout or io_or_filename == STDOUT) and dest_fd ~= STDOUT then
    C.dup2(STDERR, STDOUT)
  elseif (io_or_filename == io.stderr or io_or_filename == STDERR) and dest_fd ~= STDERR then
    C.dup2(STDOUT, STDERR)

    -- otherwise handle file-based redirection
  else
    local fd = C.open(io_or_filename, bit.bor(O_WRONLY, O_CREAT), bit.bor(S_IRUSR, S_IWUSR))
    if fd < 0 then
      return nil, strerror(string.format("failure opening file '%s'", fname))
    end
    C.dup2(fd, dest_fd)
    C.close(fd)
  end
end

exec.spawn = function (exe, args, env, cwd, stdout_redirect, stderr_redirect)
  args = args or {}

  local pid = C.fork()
  if pid < 0 then
    return nil, strerror("fork(2) failed")
  elseif pid == 0 then -- child process
    redirect(stdout_redirect, STDOUT)
    redirect(stderr_redirect, STDERR)
    local string_array_t = ffi.typeof('const char *[?]')
    -- local char_p_k_p_t   = ffi.typeof('char *const*')
    -- args is 1-based Lua table, argv is 0-based C array
    -- automatically NULL terminated
    local argv = string_array_t(#args + 1 + 1)
    for i = 1, #args do
      argv[i] = tostring(args[i])
    end
    do
      local function setenv(name, value)
        local overwrite_flag = 1
        if C.setenv(name, value, overwrite_flag) == -1 then
          return nil, strerror("setenv(3) failed")
        else
          return value
        end
      end
      for name, value in pairs(env or {}) do
        local x, e = setenv(name, tostring(value))
        if x == nil then return nil, e end
      end
    end
    if cwd then
      if C.chdir(tostring(cwd)) == -1 then return nil, strerror("chdir(2) failed") end
    end
    argv[0] = exe
    argv[#args + 1] = nil
    if C.execvp(exe, ffi.cast("char *const*", argv)) == -1 then
      return nil, strerror("execvp(3) failed")
    end
    assert(nil, "assertion failed: exec.spawn (should be unreachable!)")
  else
    if ERETRY(C.waitpid)(pid, nil, 0) == -1 then return nil, strerror("waitpid(2) failed") end
  end
end

exec.context = function(exe)
  local args = {}
  return setmetatable(args, {__call = function(_, ...)
    local n = select("#", ...)
    if n == 1 then
      for k in string.gmatch(..., "%S+") do
        args[#args+1] = k
      end
    elseif n > 1 then
      for _, k in ipairs({...}) do
        args[#args+1] = k
      end
    end
    return exec.spawn(exe, args, args.env, args.cwd, args.stdout, args.stderr)
  end})
end
exec.ctx = exec.context

exec.cmd = setmetatable({},
  {__index =
    function (_, exe)
      return function(...)
        local args
        if not (...) then
          args = {}
        elseif type(...) == "table" then
          args = ...
        else
          args = {...}
        end
        return exec.spawn(exe, args, args.env, args.cwd, args.stdout, args.stderr)
      end
    end
  })

return exec
