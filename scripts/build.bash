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

rm -rf ${dist} ${pdf_dist}
mkdir -p ${dist} ${pdf_dist}

for p in ${publishes[@]}; do
  target=$(basename $(dirname "$p"))
  mkdir -p ${dist}/${target}
  file=${src}/${target}/index.md
  echo "Build $file ..."
  ${marp} $file --html -o ${dist}/${target}/index.html
  ${marp} $file --html --pdf --allow-local-files -o ${pdf_dist}/${target}.pdf
  ${marp} $file --image png -o ${dist}/${target}/index.png
  rsync -a --include="*${images_dir}/" --include="*.jpg" --include="*.png" --include="*.gif" --exclude="*" ${src}/${target}/ ${dist}/${target}/
done

echo "Add CNAME ..."
echo $cname > ${dist}/CNAME
echo "Add .nojekyll ..."
touch ${dist}/.nojekyll

echo "Completed Build Successfully."
