using module PSKoans
[Koan(Position = 312)]
param()
<#
    XML, or eXtensible Markup Language, is one of the more common text-based formats for serialized data.

    With a number of specialised commands  and the  the .NET framework available PowerShell is very capable
    of working with XML documents and XML data in general.
#>
Describe 'About XML' {

    Context 'XML as an object' {
        It 'can cast a string to an XML document' {
            <#
                Perhaps the most widely used way of working with XML is to treat an XML document as a object.

                This makes use of the [Xml] type accelerator which provides a quick way of accessing the
                [System.Xml.XmlDocument] type.
            #>

            $xml = [Xml]'<documentRoot><element>Hello world</element></documentRoot>'

            # Each node is presented as a property.
            '____' | Should -Be $xml.DocumentRoot.element
        }

        It 'can convert output from Get-Content to an XML document' {
            <#
                It is often desirable to read an XML file to work with in PowerShell.

                Get-Content is widely used to draw XML content in.
            #>

            $path = Join-Path -Path $TestDrive -ChildPath document.xml
            Set-Content -Path $path -Value @'
<documentRoot>
    <element>A short XML file</element>
</documentRoot>
'@

            # The output from Get-Content can be cast to Xml, even when the document has more than one line.
            $xml = [Xml](Get-Content -Path $path)

            $rootElement = '____'

            $xml.$rootElement.Element | Should -Be 'A short XML file'
        }

        It 'for larger files, the Load method of XmlDocument is faster' {
            Set-Content -Path $path -Value @'
<documentRoot>
    <element>This is still a short XML file</element>
</documentRoot>
'@

            $xml = [Xml]::new()
            <#
                .NET methods need a fully-qualified path. A relative PowerShell path will resolve to a path relative to
                the working directory for the PowerShell process; often the System32 directory.
            #>
            $xml.Load($path)

            $xml.____.____ | Should -Be 'This is still a short XML file'
        }

        It 'is all text' {
            # All values in XML documents are strings. Values which represent other types must be converted.
            $xml = [Xml]'<root><element>1</element></root>'

            [____] | Should -Be $xml.root.element.GetType()
        }

        It 'can expand arrays in a similar way to PowerShell' {
            # If a document contains an array it can be expanded in a similar manner to any other PowerShell object.
            $xml = [Xml]@'
<root>
    <element>1</element>
    <element>2</element>
    <element>3</element>
    <element>4</element>
    <element>5</element>
</root>
'@

            $xml.____.____ | Should -Be '1', '2', '3', '4', '5'
        }
    }

    Context 'About Select-Xml' {
        <#
            Treating XML as any other object makes XML documents easy to work with, it offers tremendous convenience.
            For larger documents the approach can be slow and XPath, a query language for XML becomes important.

            The Select-Xml command can work with a path to an XML file, a path, or an XML document object.
        #>

        It 'can select an XML element from a string' {
            $xmlContent = @'
<root>
    <someElement>
        <aNestedElement>value</aNestedElement>
    </someElement>
</root>
'@

            # In an XPath expression, //Name can be used to find all elements called Name, anywhere in the document
            $result = Select-Xml -Content $xmlContent -XPath '//aNestedElement'

            #
            '____' | Should -Be $result.Node.'#text'
        }
    }

    Context 'About SelectSingleNode and SelectNodes' {

    }

    Context 'About ConvertTo-Xml' {

    }

    Context 'Writing XML documents in PowerShell' {

    }

    Context 'Modifying XML documents' {

    }

    Context 'Working with namespaces' {

    }

    Context 'Working with an XML schema' {

    }

    Context 'About CLI XML' {

    }

    Context 'About System.Xml.Linq' {

    }
}

