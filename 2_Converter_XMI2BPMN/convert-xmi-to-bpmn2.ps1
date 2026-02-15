# XSLT Converter: XMI to BPMN2
# Usage: .\convert-xmi-to-bpmn2.ps1

$xmiFile = "derive.xmi"
$xslFile = "xmi2bpmn2.xsl"
$outputFile = "derive.bpmn2"

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
