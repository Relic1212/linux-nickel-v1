

 {
_pkgsArray=[
    import "../pkgs/musl/musl-stage-0.ncl",
    import "../pkgs/llvm/llvm-stage-0.ncl",
    import "../pkgs/llvm/llvm-baselibs-stage-0.ncl",
    import "../pkgs/linux-headers/linux-headers-stage-0.ncl",
    (import "../pkgs/libssp-nonshared/libssp-nonshared.ncl").libsspNonsharedStage0,
    (import "../pkgs/busybox/busybox-stage-0.ncl"),
    (import "../pkgs/gnumake/gnumake.ncl").gnumakeStage1,
    (import "../pkgs/python/python.ncl").pythonStage1,
    (import "../pkgs/cmake/cmake.ncl").cmakeStage1,
    (import "../pkgs/m4/m4.ncl").m4Stage1,
    (import "../pkgs/flex/flex.ncl").flexStage1,
    (import "../pkgs/bison/bison-stage-1.ncl"),
    (import "../pkgs/llvm/llvm-stage-1.ncl"),
    {
        name=pkgsRecord."flex-stage-1".name ++ "-other"
        
    }
    
],
pkgsRecord=std.record.from_array
(std.array.map (fun p=>{field=p.name,value=p}) _pkgsArray)
 }
