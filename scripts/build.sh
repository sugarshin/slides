#!/bin/bash

set -eu

readonly marp=node_modules/.bin/marp
readonly src=src
readonly dist=dist
readonly pdf_dist=pdf
readonly publishfile=publish
readonly publishes=$(find $src -type f -name $publishfile)
readonly images_dir=images
readonly cname=slides.sugarshin.net

mkdir -p ${dist} ${pdf_dist}

for p in ${publishes[@]}; do
  target=$(basename $(dirname "$p"))
  mkdir -p ${dist}/${target}
  file=${src}/${target}/index.md
  echo "Build $file ..."
  ${marp} $file --html -o ${dist}/${target}/index.html
  ${marp} $file --html --pdf --allow-local-files -o ${pdf_dist}/${target}.pdf
  ${marp} $file --image png -o ${dist}/${target}/index.png

  echo "Copy ${src}/${target}/${images_dir} ..."
  mkdir -p ${dist}/${target}/${images_dir}
  find ${src}/${target}/${images_dir} -type f -iname "*.png" -exec cp {} ${dist}/${target}/${images_dir}/ \;
  # TODO: other image ext
done

echo "Add CNAME ..."
echo $cname > ${dist}/CNAME
echo "Add .nojekyll ..."
touch ${dist}/.nojekyll

echo "Completed Build Successfully."
