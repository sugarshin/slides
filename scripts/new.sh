#!/bin/bash

set -eu

if [ $# != 2 ]; then
  echo "[ERROR] an argument should be 2. the first argument is the title of the slide, the second argument is the pathname of the slide."
  exit 1
fi

readonly title=$1
readonly pathname=$2

readonly src=src
readonly dir=${src}/${pathname}
readonly images_dir=${dir}/images

if [ -d ${dir} ]; then
  echo -e "[ERROR] ./${dir} already exsits.\n"
  exit 1
fi

mkdir -p ${images_dir}

images_gitkeep=${images_dir}/.gitkeep
echo ${images_gitkeep}
touch ${images_gitkeep}

indexmd=${dir}/index.md
echo ${indexmd}
cat << EOF >> ${indexmd}
---
title: ${title} - @sugarshin's slide | slides.sugarshin.net
description: ${title} - @sugarshin's slide | slides.sugarshin.net
url: https://slides.sugarshin.net/${pathname}
image: https://slides.sugarshin.net/${pathname}/index.png
---

# ${title}

@sugarshin

---

TBD

---

<img src="/${pathname}/images/sample.png">
EOF

echo -e "\n[INFO] Completed successfully\n"
