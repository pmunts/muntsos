-- Parent package for lawn sprinkler (and other irrigation) systems

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO;

PACKAGE Sprinkler IS

  Error : EXCEPTION;

  -- Define a type for watering zone numbers

  TYPE ZoneNumber IS NEW Positive;

  PACKAGE ZoneNumber_IO IS NEW Ada.Text_IO.Integer_IO(ZoneNumber);

  -- Define an abstract interface for watering zone valves

  TYPE ValveInterface IS INTERFACE;

  TYPE Valve IS ACCESS ALL ValveInterface'Class;

  FUNCTION Get(Self : IN OUT ValveInterface) RETURN Boolean IS ABSTRACT;

  PROCEDURE Put(Self : IN OUT ValveInterface; state : Boolean) IS ABSTRACT;

  -- Define a type for watering times

  TYPE Hour IS DELTA 0.01 RANGE 0.0 .. 24.99;  -- Hours in a day

  PACKAGE Hour_IO  IS NEW Ada.Text_IO.Fixed_IO(Hour);

END Sprinkler;
