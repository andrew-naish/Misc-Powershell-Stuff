function InitialiseXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String] $XmlPath,

        [Parameter(Mandatory=$false)]
        [String] $RootElementName="Root"
    )
    
    # settings
    $xml_settings = New-Object System.Xml.XmlWriterSettings
    $xml_settings.Indent = $true
    $xml_settings.IndentChars = "    "

    # create xmlwriter and the strt of the doc
    $XmlWriter = [System.XML.XmlWriter]::Create("$XmlPath", $xml_settings)
    $XmlWriter.WriteStartDocument()
    $XmlWriter.WriteStartElement("$RootElementName")

    # return
    return $XmlWriter

}

function FinaliseAnCloseXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [System.XML.XmlWriter] $XmlWriter
    )

    # write last element
    $XmlWriter.WriteEndElement()

    # close the doc
    $XmlWriter.WriteEndDocument()
    $XmlWriter.Flush()
    $XmlWriter.Close()
    
}

function WriteElement {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [System.XML.XmlWriter] $XmlWriter,

        [Parameter(Mandatory=$true)]
        [String] $ElementName,

        [Parameter(Mandatory=$false)]
        [String] $ElementValue,

        [Parameter(Mandatory=$false)]
        [Switch] $BaseElementNoEnd,

        [Parameter(Mandatory=$false)]
        [Hashtable] $Attributes,

        [Parameter(Mandatory=$false)]
        [Hashtable] $MemberElements
    )

    # start: base element
    $XmlWriter.WriteStartElement("$ElementName")

        # if we need attributes, add them
        if ($Attributes -ne $null) 
        {
            $Attributes.GetEnumerator() | ForEach-Object {
                $XmlWriter.WriteAttributeString($_.Key, $_.Value)
            }
        }

        # if base element has a value, add it now
        if ( -not ([String]::IsNullOrEmpty($ElementValue)) )
        {
            $XmlWriter.WriteString($ElementValue)
        }

        # add any member elements if needed
        if ($MemberElements -ne $null) 
        {
            $MemberElements.GetEnumerator() | ForEach-Object {
                $XmlWriter.WriteStartElement($_.Key)
                $XmlWriter.WriteString($_.Value)
                $XmlWriter.WriteEndElement()
            }
        }

    # end: base element (only if BaseElementNoEnd was not provided)
    if (-not $BaseElementNoEnd) 
    {
        $XmlWriter.WriteEndElement()
    }

    # sssend it!
    return $XmlWriter

}

function WriteElementBulk {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [System.XML.XmlWriter] $XmlWriter,

        [Parameter(Mandatory=$true)]
        [Hashtable] $Elements
    )

    # add elements
    if ($Elements -ne $null) 
    {
        $Elements.GetEnumerator() | ForEach-Object {
            $XmlWriter.WriteElementString("$($_.Key)", "$($_.Value)")
        }
    }

    return $XmlWriter

}

function WriteRaw {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [System.XML.XmlWriter] $XmlWriter,

        [Parameter(Mandatory=$false)]
        [String] $InputString,

        [Parameter(Mandatory=$false)]
        [String] $Indent = "    ",

        [Parameter(Mandatory=$false)]
        [Int] $IndentPadMultiplyer = 0,

        [Parameter(Mandatory=$false)]
        [String] $PreLineBreak = "`r`n",

        [Parameter(Mandatory=$false)]
        [String] $PostLineBreak = "`r`n"
    )

    # generate indent padding
    $indent_padding = $Indent*$IndentPadMultiplyer

    # pre linebreak, indent, content, post linebreak
    $xml_line = "{0}{1}{2}{3}" -f $PreLineBreak, $indent_padding, $InputString, $PostLineBreak
    $XmlWriter.WriteRaw( $xml_line )

    # yeet!
    return $XmlWriter
}