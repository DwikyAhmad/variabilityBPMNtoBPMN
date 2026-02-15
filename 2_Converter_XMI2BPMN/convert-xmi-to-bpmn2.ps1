# XSLT Converter: XMI to BPMN2
# Usage: .\convert-xmi-to-bpmn2.ps1

$xmiFile = ".\4_Input_Output\output.xmi"
$xslFile = ".\2_Converter_XMI2BPMN\xmi2bpmn2.xsl"
$outputFile = ".\4_Input_Output\output.bpmn2"

Write-Host "Converting $xmiFile to $outputFile..." -ForegroundColor Cyan

try {
    # Load XSLT
    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform
    $xslt.Load($xslFile)
    
    # Transform
    $xslt.Transform($xmiFile, $outputFile)
    
    Write-Host "Successfully converted to $outputFile" -ForegroundColor Green
    Write-Host "You can now open it in BPMN2 Modeler" -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
