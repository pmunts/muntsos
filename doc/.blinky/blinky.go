package main

import (
  "fmt"
  "time"
  "munts.com/interfaces/GPIO"
  "munts.com/objects/Error"
  "munts.com/objects/simpleio/Designator"
  "munts.com/objects/simpleio/GPIO_libsimpleio"
)

func main() {
  fmt.Printf("\nMuntsOS Go LED Test\n\n")

  // Configure a GPIO output to drive an LED

  var outp GPIO.Pin
  var err error

  outp, err = GPIO_libsimpleio.NewOutput(Designator.Designator { 0, 26 }, true)
  Error.Exit(err, "NewOutput() failed")

  var state bool

  // Flash the LED forever (until killed)

  fmt.Printf("Press CONTROL-C to exit.\n");

  for {
    state, err = outp.Get()
    Error.Exit(err, "outp.Get() failed")

    err = outp.Put(!state)
    Error.Exit(err, "outp.Put() failed")

    time.Sleep(500*time.Millisecond)
  }
}
