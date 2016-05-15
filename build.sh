#!/bin/bash

mkdir -p pencil-iron-icons
mkdir -p pencil-iron-icons/Icons
cat << EOF > pencil-iron-icons/Definition.xml
<?xml version="1.0" encoding="UTF-8"?>
<Shapes
    xmlns="http://www.evolus.vn/Namespace/Pencil"
    xmlns:p="http://www.evolus.vn/Namespace/Pencil"
    xmlns:svg="http://www.w3.org/2000/svg"
    id="com.mobily1.iron-icons"
    displayName="Polymer's iron-icons"
    description="All of Google Polymer's iron-icons icons https://elements.polymer-project.org/elements/iron-icons?view=demo:demo/index.html"
    author="Tony Mobily">

    <Properties>
        <PropertyGroup>
            <Property name="fillColor" displayName="Icon color" type="Color">#000000ff</Property>
        </PropertyGroup>
    </Properties>
EOF


for file in iron av communication device editor hardware image maps notification places social;do
  rm $file-icons.html
  wget https://raw.githubusercontent.com/PolymerElements/iron-icons/master/$file-icons.html

  cat $file-icons.html | grep "^<g"  | while read line; do
    echo PROCESSING:
    echo $line;
    id=`echo $line | cut -d \" -f 2`;
    id="$file-$id"
    # d=`echo $line | cut -d \" -f 4`;echo $path;
    d=`echo $line | cut -d ">" -f 2- | rev | cut -c 5- | rev`;echo $d;
    echo ID FOR THIS LINE: $id;
    echo DRAWING DATA FOR THIS LINE: $d;

    # Make up the icon, with the right name
    cat << EOF > pencil-iron-icons/Icons/$id.svg
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg"
         xmlns="http://www.w3.org/2000/svg" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
         xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" inkscape:version="0.48.1"
         width="64" height="64" id="svg2" version="1.1">

         $d

    </svg>
EOF
    convert -resize 24x24 pencil-iron-icons/Icons/$id.svg pencil-iron-icons/Icons/$id.png
    rm pencil-iron-icons/Icons/$id.svg

    cat << EOF >> pencil-iron-icons/Definition.xml

  <Shape id="$id" displayName="$id" icon="Icons/$id.png">
      <Properties>
          <PropertyGroup>
              <Property name="box" type="Dimension" p:lockRatio="true">24,24</Property>
          </PropertyGroup>
          <PropertyGroup name="Background">
              <Property name="fillColor" displayName="Color" type="Color">
                  <E>\$\$fillColor</E>
              </Property>
          </PropertyGroup>
      </Properties>
      <Behaviors>
          <For ref="icon">
              <Transform>scale(\$box.w/24, \$box.h/24)</Transform>
              <Fill>\$fillColor</Fill>
          </For>
          <For ref="bgRect">
              <Box>\$box</Box>
          </For>
      </Behaviors>
      <p:Content xmlns="http://www.w3.org/2000/svg">
          <rect id="bgRect" style="fill: #000000; fill-opacity: 0; stroke: none;" x="0" y="0"/>
          <g id="icon">
              $d
          </g>
      </p:Content>
  </Shape>
EOF

  done
  rm $file-icons.html
done

cat << EOF >> pencil-iron-icons/Definition.xml
  </Shapes>
EOF
