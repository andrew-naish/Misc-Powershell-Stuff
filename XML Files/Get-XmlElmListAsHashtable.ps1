function Get-XmlElmListAsHashtable {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            if ($_.HasChildNodes) { return $true } 
            else {
                throw "The element provided does not have child elements"
            }
        })]
        [System.Xml.XmlElement]$InputXMLElement,

        [Parameter(Mandatory=$false)]
        [string[]]$ExcludeTags
    )

    $child_elements = $InputXMLElement.ChildNodes |
        Select-Object "Name", "#text" | Group-Object "Name"

    $output_hash = @{}
    foreach ($child_element in $child_elements) {
	
        $child_element_name = $child_element.Name
		
        if ($child_element_name -in $ExcludeTags) 
		{ continue } # skip this item in the loop

        [string[]]$child_element_value = $child_element.Group | 
			Select -ExpandProperty "#text"
        $output_hash.Add( $child_element_name, $child_element_value )
		
    }

    return $output_hash
}

# [xml]$imput_xml = gc ".\test_file.xml"
<#
[xml]$imput_xml = "
<root>
    <Email>
		<Recipients>
			<To>user1@blah.com</To>
			<To>user2@blah.com</To>
			<Cc>also.user1@blah.com</Cc>
			<Cc>also.user2@blah.com</Cc>
			<Cc></Cc>
			<Bcc>secret.user1@blah.com</Bcc>
			<Bcc prop="v">
				<Inner prop="inner">
					<Thing>Val</Thing>
				</Inner>
			</Bcc>
		</Recipients>
	</Email>
</root>
"
#>
# Get-XmlElmListAsHashtable $imput_xml.root.things