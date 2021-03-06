<?xml version="1.0" encoding="UTF-8"?>
<Export generator="Cache" version="25">
<Class name="stat.install">
<Super>%RegisteredObject</Super>
<TimeCreated>65842,82410.909148</TimeCreated>

<Method name="install">
<ClassMethod>1</ClassMethod>
<FormalSpec>phase,when</FormalSpec>
<Implementation><![CDATA[
 set prod=$P($SYSTEM.Version.GetProduct()," ")
 if prod="IRIS" { set isiris=1 } else { set isiris=0 }
 set fsdlm=$E($zu(12),$L($zu(12)))
 set libdbdir=$zu(12)_$case(isiris,1:"iris",0:"cache")_"lib"_fsdlm
 set nspace=$znspace if nspace'="%SYS" ZN "%SYS"
 set libdbobj=##class(SYS.Database).%OpenId(libdbdir,,.retOpen)
 if +retOpen { set libdbro=libdbobj.ReadOnly } else { set libdbro="" }
 if libdbro=1 {
   set libdbobj.ReadOnly=0 set retSave=libdbobj.%Save()
   if +retSave=0 { kill libdbobj quit $LB(0,"error remount lib database as read write") }
 }
 set rtn="stat.install"
 if nspace'="%SYS" { kill ^|"%SYS"|rMAC(rtn) merge ^|"%SYS"|rMAC(rtn)=^|nspace|rMAC(rtn) }
 set rtnobj=##class(%Routine).%OpenId("stat.install.MAC")
 set ret=rtnobj.Compile("cd")
 do zpm^stat.install($G(phase),$G(when))
 if libdbro=1 {
   set libdbobj.ReadOnly=1 set retSave=libdbobj.%Save()
   if +retSave=0 { kill libdbobj quit $LB(0,"error remount lib database as read write") }
 }
 if nspace'="%SYS" {
   ZN nspace
   set ret1=##class(%Routine).Delete(rtn_".MAC",2,1)
   set ret2=##class(%Routine).Delete(rtn_".OBJ")
   if '(+ret1=1&&(+ret2=1)) W "error remove "_rtn,!
   try { set ret=$zpm("uninstall stat") } catch {}
 }
 else {
   merge savedrtn=^rMAC(rtn)
   try { set ret=$zpm("uninstall stat") } catch {}
   merge ^rMAC(rtn)=savedrtn kill savedrtn
   set rtnobj=##class(%Routine).%OpenId("stat.install.MAC")
   set ret=rtnobj.Compile("cd")
 } 
]]></Implementation>
</Method>
</Class>
</Export>
