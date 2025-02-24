//%attributes = {}
#DECLARE() : cs:C1710.AIKit.OpenAI
var $client:=cs:C1710.AIKit.OpenAI.new()

If ((Folder:C1567(fk desktop folder:K87:19).file("apiKey").exists) && ($client.apiKey#Null:C1517))
	$client.apiKey:=Folder:C1567(fk desktop folder:K87:19).file("apiKey").getText()
End if 

If (Length:C16(String:C10($client.apiKey))=0)
	$client.apiKey:=String:C10(Form:C1466.openAIAPIKey)
End if 

If (Length:C16(String:C10($client.apiKey))=0)
	var $key:=Request:C163("Open API key"; "")
	If ((OK=1) && (Length:C16($key)>0))
		Form:C1466.openAIAPIKey:=$key
	End if 
End if 


return $client