#Connect to the Compliance Center through Powershell
Write-Host "Connecting to the Microsoft Security and Compliance Center.  Please enter global admin credentials:" -ForegroundColor Cyan
Connect-IPPSSession

#Display a list of current DLP rules and prompt for user input
Get-DLPComplianceRule
Write-Host "Displaying existing compliance rules above.  Please input the name of the rule you wish to export to XML." -ForegroundColor Magenta
$rule =  Read-Host -Prompt 'Rule Name'

#Export the rule to an XML file and show instructions for modifying fields
Get-DlpComplianceRule -Identity $rule | select * | Export-Clixml .\$rule.xml
Write-Host "Rule exported to XML and saved in current directory as $rule.xml" -ForegroundColor DarkYellow
Write-Host "Please modify the XML file's 'RecipientDomainIs' and 'ExceptIfRecipientDomainIs' fields with the new domains needed." -ForegroundColor DarkYellow

#Prompt user for input with new filename and upload the modified XML back to the Compliance Center to update the previously exported rule
$modified_rule = Read-Host -Prompt "Please enter the modified XML document name here, omitting the file extension (e.g. 'newfile')"
$upload_xml = Import-Clixml .\$modified_rule.xml
Set-DLPComplianceRule -Identity $rule -RecipientDomainIs $($upload_xml.RecipientDomainIs) -ExceptIfRecipientDomainIs $($upload_xml.ExceptIfRecipientDomainIs)

Write-Host "If there are no errors above, the rule has been modified.  Please confirm the changes reflected in the Compliance Portal." -ForegroundColor Green