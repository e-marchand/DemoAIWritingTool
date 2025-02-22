//%attributes = {}
#DECLARE() : cs:C1710.AIKit.OpenAI
var $client:=cs:C1710.AIKit.OpenAI.new()

If ((Folder:C1567(fk desktop folder:K87:19).file("apiKey").exists) && ($client.apiKey#Null:C1517))
	$client.apiKey:=Folder:C1567(fk desktop folder:K87:19).file("apiKey").getText()
End if 

return $client