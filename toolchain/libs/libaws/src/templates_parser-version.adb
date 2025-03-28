with GNAT.Bind_Environment;

separate (Templates_Parser)
function Version return String is
   use GNAT;
begin
   return Bind_Environment.Get ("version");
end Version;
