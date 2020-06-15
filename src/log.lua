-- shamelessly stolen from https://stackoverflow.com/questions/52579137/i-need-the-lua-math-library-in-nodemcu
return function (x)
  assert(x > 0)
  local a, b, c, d, e, f = x < 1 and x or 1/x, 0, 0, 1, 1
  repeat
     repeat
        c, d, e, f = c + d, b * d / e, e + 1, c
     until c == f
     b, c, d, e, f = b + 1 - a * c, 0, 1, 1, b
  until b <= f
  return a == x and -f or f
end
