

If ((Form event code:C388=On Clicked:K2:4) && (Right click:C712))
	
	var $fullText : Text:=Form:C1466.text
	If (Length:C16($fullText)=0)
		$fullText:=Get edited text:C655()
	End if 
	
	var $text:=$fullText
	GET HIGHLIGHT:C209(*; "input"; $start; $end)
	If ($start<$end)
		$text:=Substring:C12($fullText; $start; $end-$start)
	End if 
	
	If (Length:C16($text)=0)
		return 
	End if 
	
	var $menu:=cs:C1710.menu.new()
	var $key : Text
	For each ($key; cs:C1710.WritingTool.me.properties)
		If ($key="|")
			$menu.line()
		Else 
			$menu.append(Uppercase:C13($key[[1]])+Substring:C12($key; 2); $key)
		End if 
	End for each 
	
	var $trMenu:=cs:C1710.menu.new()
	var $lang : Text
	For each ($lang; cs:C1710.WritingTool.me.translates)
		$trMenu.append(cs:C1710.WritingTool.me.translateIcon($lang)+" "+$lang; "translateTo"+$lang)
	End for each 
	
	$menu.line()
	$menu.append("Translate"; $trMenu)
	
	
	If ($menu.popup().selected)
		
		var $client : cs:C1710.AIKit.OpenAI:=CreateOpenAIClient()
		var $result:=$client.chat.create(cs:C1710.WritingTool.me[$menu.choice]).prompt($text)
		
		If ($result.success)
			Form:C1466.text:=Replace string:C233($fullText; $text; $result.choice.message.text)
		End if 
		
		
	End if 
End if 