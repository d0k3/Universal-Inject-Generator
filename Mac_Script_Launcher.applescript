activate
display dialog "Make sure this script is placed in your Universal Inject Generator folder before proceeding!" buttons {"Quit", "Proceed"} default button 2
if button returned of result is "Quit" then
	error number -128
end if


set UnixPath to POSIX path of ((path to me as text) & "::")
set QuotedPath to quoted form of UnixPath

tell application "Terminal"
	reopen
	activate
	do script "cd " & QuotedPath in window 1
	delay 1
	do script "./go.sh" in window 1
end tell

