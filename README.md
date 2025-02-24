# Demo Writing tools

Edit your current input text with AI.

<img width="292" alt="Screenshot 2025-02-24 at 11 04 12" src="https://github.com/user-attachments/assets/c41395d3-92f2-45b1-b868-8d51843dc303" />

## Key features

All done by chooising a prompt from class [WritingTool](Project/Sources/Classes/WritingTool.4dm)

### rewrite 
- proofread, rewrite
- friendly, professional, concise
- summary, keyPoints, table

### translate 

- English, French, ...

### generate 

- simplifiedExplanation, detailledExplanation
- responseGenerator, titleGenerator

## Prerequisite

This project depend on private project [4D AIKit](https://github.com/4d/4d-aikit). 

It will be  download using project dependencies manager. You must setup a github token to access it.

## Setup OpenAPI

Go to  [CreateOpenAIClient](Project/Sources/Methods/CreateOpenAIClient.4dm) method to setup your API key and why not baseURL for another provided.
