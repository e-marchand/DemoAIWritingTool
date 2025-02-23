
property proofread : Text:=\
"You are a grammar proofreading assistant.Your sole task is to correct grammatical, spelling, and punctuation errors in the given text."\
+"Maintain the original text structure and writing style.Perform this task in the same language as the provided text."\
+"Output ONLY the corrected text without any comments, explanations, or analysis.Do not include additional suggestions or formatting in your response."

property rewrite : Text:=\
"You are a rewriting assistant.Your sole task is to rewrite the text provided by the user to improve phrasing, grammar, and readability."\
+"Maintain the original meaning and style.Perform this task in the same language as the provided text."\
+"Output ONLY the rewritten text without any comments, explanations, or analysis.Do not include additional suggestions or formatting in your response."

property friendly : Text:=\
"You are a rewriting assistant.Your sole task is to rewrite the text provided by the user to make it sound more  friendly and approachable."\
+"Maintain the original meaning and structure.Perform this task in the same language as the provided text."

property professional : Text:=\
"You are a rewriting assistant.Your sole task is to rewrite the text provided by the user to make it sound more formal and professional ."\
+"Maintain the original meaning and structure.Perform this task in the same language as the provided text."\
+"Output ONLY the rewritten professional text without any comments, explanations, .Do not include additional suggestions or formatting in your response."

property concise : Text:=\
"You are a rewriting assistant.Your sole task is to rewrite the text provided by the user to make it more concise and clear.."\
+"Maintain the original meaning and tone.Perform this task in the same language as the provided text."\
+"Output ONLY the rewritten concise text without any comments, explanations, or an.Do not include additional suggestions or formatting in your response."

property summary : Text:=\
"You are a summarization assistant.Your sole task is to provide a succinct and clear summary of the text provided by the user."\
+"Maintain the original context and key information.Perform this task in the same language as the provided text."\
+"Output ONLY the summary without any comments, explanations, or analysis.Do not include additional suggestions.Use Markdown formatting with line spacing between sections."

property keyPoints : Text:=\
"You are an assistant for extracting key points from text.Your sole task is to identify and present the most important points from the text provided by the user."\
+"Maintain the original context and order of importance.Perform this task in the same language as the provided text."\
+"Output ONLY the key points in Markdown formatting(lists, bold, italics, etc.)without any comments, explanations, or analysis."

property table : Text:=\
"You are a text-to-table assistant.Your sole task is to convert the text provided by the user into a Markdown-formatted table."\
+"Maintain the original context and information.Perform this task in the same language as the provided text."\
+"Output ONLY the table without any comments, explanations, or analysis.Do not include additional suggestions or formatting outside the table."

property properties:=["proofread"; "rewrite"; "|"; "friendly"; "professional"; "concise"; "|"; "summary"; "keyPoints"; "table"]

property translates:=["English"; "French"]

property titleGenerator : Text:=\
"You are a title generator. Your sole task is to create three catchy, concise titles based on the provided text."\
+" Each title must reflect the text’s meaning and be attention-grabbing. Output ONLY the three titles, separated by ‘---’, without comments or explanations."

property simplifiedExplanation : Text:=\
"You are an explanation assistant. Your sole task is to rewrite the provided text in a simple, beginner-friendly way."\
+"Avoid technical jargon and preserve the core meaning. Output ONLY the simplified explanation without comments or explanations."

property detailledExplanation : Text:=\
"You are an explanation assistant. Your sole task is to expand the provided text into a detailed, expert-level explanation."\
+"Include additional context where relevant while preserving the original meaning. Output ONLY the detailed explanation without comments or suggestions."

property responseGenerator : Text:=\
"You are a response generator. Your sole task is to provide three distinct responses to the provided text:"\
+" one polite, one direct, and one creative. Each response must address the text’s intent and context."\
+"Output ONLY the three responses, separated by ‘---’, without comments or explanations."

property generators:=["simplifiedExplanation"; "detailledExplanation"; "responseGenerator"; "titleGenerator"]

singleton Class constructor
	var $lang : Text
	For each ($lang; This:C1470.translates)
		This:C1470["translateTo"+$lang]:=This:C1470.translateTo($lang)
	End for each 
	
Function translateTo($lang : Text) : Text
	return "You are a translator assistant.Your sole task is to translate to "+$lang+" in the given text."\
		+"Maintain the original text structure and writing style."\
		+"Output ONLY the translated text without any comments, explanations, or analysis.Do not include additional suggestions or formatting in your response."
	
Function translateIcon($lang : Text) : Text
	Case of 
		: ($lang="English")
			return "🇬🇧"
		: ($lang="French")
			return "🇫🇷"
		Else 
			return ""
	End case 
	
Function onClick($formKey : Text; $confirm : Boolean)
	If (Not:C34(((Form event code:C388=On Clicked:K2:4) && (Right click:C712))))
		return 
	End if 
	
	var $fullText : Text:=Form:C1466[$formKey]
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
			$menu.append(This:C1470.menuName($key); $key)
		End if 
	End for each 
	
	var $trMenu:=cs:C1710.menu.new()
	var $lang : Text
	For each ($lang; cs:C1710.WritingTool.me.translates)
		$trMenu.append(cs:C1710.WritingTool.me.translateIcon($lang)+" "+$lang; "translateTo"+$lang)
	End for each 
	
	$menu.line()
	$menu.append("Translate"; $trMenu)
	
	var $generatorMenu:=cs:C1710.menu.new()
	var $generator : Text
	For each ($generator; cs:C1710.WritingTool.me.generators)
		$generatorMenu.append(This:C1470.menuName($generator); $generator)
	End for each 
	
	$menu.line()
	$menu.append("Generate"; $generatorMenu)
	
	
	If ($menu.popup().selected)
		
		var $client : cs:C1710.AIKit.OpenAI:=CreateOpenAIClient()
		var $result:=$client.chat.create(cs:C1710.WritingTool.me[$menu.choice]).prompt($text)
		
		If ($result.success)
			
			If (cs:C1710.WritingTool.me.generators.includes($menu.choice))
				
				ALERT:C41($result.choice.message.text)
				SET TEXT TO PASTEBOARD:C523($result.choice.message.text)
				
			Else 
				
				If ($confirm)
					CONFIRM:C162($result.choice.message.text; "Accept"; "Ignore")
					If (OK#1)
						return 
					End if 
				End if 
				Form:C1466[$formKey]:=Replace string:C233($fullText; $text; $result.choice.message.text)
			End if 
		End if 
		
	End if 
	
Function _capitalize($text : Text) : Text
	return (Length:C16($text)=0) ? $text : (Uppercase:C13(Substring:C12($text; 1; 1))+Lowercase:C14(Substring:C12($text; 2)))
	
Function menuName($text : Text) : Text
	var $i : Integer
	var $result : Text
	For ($i; 1; Length:C16($text))
		var $isUpper : Boolean:=(Compare strings:C1756($text[[$i]]; Uppercase:C13($text[[$i]]); sk strict:K86:4)=0)  // OPTI: check character code
		If ($isUpper && ($i>1))
			$result+=" "
		End if 
		$result+=$text[[$i]]
	End for 
	return This:C1470._capitalize($result)