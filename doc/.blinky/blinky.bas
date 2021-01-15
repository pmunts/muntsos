print "MuntsOS LED Test";;

' Open the GPIO output

fd = libsimpleio.gpio_open(0, 26, 1, 0)

' Flash the LED

while true
  libsimpleio.gpio_write(fd, NOT libsimpleio.gpio_read(fd))
  delay(500000)
wend
