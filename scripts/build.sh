#!/bin/bash

set -euo pipefail

readonly marp=node_modules/.bin/marp
readonly frontmatter=node_modules/.bin/yaml-front-matter
readonly md_it=node_modules/.bin/markdown-it
readonly src=src
readonly dist=dist
readonly pdf_dist=pdf
readonly publishfile=publish
publishes=$(find $src -type f -name $publishfile)
readonly publishes
readonly images_dir=images
readonly origin=slides.sugarshin.net
readonly title="@sugarshin's slides"

echo -e '[INFO] Prepare directories...\n'
mkdir -p ${dist} ${pdf_dist}

echo -e '[INFO] Build slides...\n'
for p in ${publishes}; do
  target=$(basename "$(dirname "${p}")")
  mkdir -p ${dist}/"${target}"
  file=${src}/${target}/index.md
  echo "[INFO] Build $file ..."
  ${marp} "$file" --html -o ${dist}/"${target}"/index.html
  ${marp} "$file" --html --pdf --allow-local-files -o ${pdf_dist}/"${target}".pdf
  ${marp} "$file" --image png -o ${dist}/"${target}"/index.png

  echo "[INFO] Copy ${src}/${target}/${images_dir} ..."
  mkdir -p ${dist}/"${target}"/${images_dir}
  find ${src}/"${target}"/${images_dir} -type f -iname "*.png" -exec cp {} ${dist}/"${target}"/${images_dir}/ \;
  # TODO: other image ext
done

echo -e '[INFO] Build index...\n'

md_string="# ${title}\n\n"
i=0
for p in ${publishes}; do
  if [ ! $i = 0 ]; then
    md_string+='\n'
  fi
  name=$(basename "$(dirname "${p}")")
  file=${src}/${name}/index.md
  slide_title="$(cat < "${file}" | ${frontmatter} | jq -r .title)"
  md_string+="- [${slide_title}](/${name})"
  i=$((++i))
done

# TODO:
md_string+='\n'
md_string+='- [LIFF JS SDK Development Team Introduction](/202110_hiring_event.pdf)'
md_string+='\n'
md_string+='- [LIFFプラグインの紹介](/shingosato-connpass-event-220511.pdf)'

content=$(echo -e -n "$md_string" | ${md_it})

cat << EOF > ${dist}/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>${title} | ${origin}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
  </head>
  <body>
    <div class="container mt-5">
      ${content}
    </div>
  </body>
</html>
EOF

echo -e "[INFO] Copy PDF slides...\n"
find resources -type f -name '*.pdf' -exec cp "{}" "${dist}" \;
echo -e "[INFO] Add CNAME...\n"
echo $origin > ${dist}/CNAME
echo -e "[INFO] Add .nojekyll...\n"
touch ${dist}/.nojekyll
echo -e "[INFO] Copy static...\n"
cp -nR static/. "${dist}"

echo "[INFO] Completed Build Successfully."
