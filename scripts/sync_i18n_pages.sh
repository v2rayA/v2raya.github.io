#!/bin/bash

doc_path="$(dirname $(dirname ${BASH_SOURCE[0]}))/content"

for md_file in $(find ${doc_path} -type f -name "*.md" | grep -v ".en.md$"); do
    [ ! -f "${md_file%%.md}.en.md" ] && \
    echo "+++ ${md_file%%.md}.en.md" && \
    cp "${md_file}" "${md_file%%.md}.en.md"
done

for md_file in $(find ${doc_path} -type f -name "*.en.md"); do
    [ ! -f "${md_file%%.en.md}.md" ] && \
    echo "--- ${md_file}" && \
    rm "${md_file}"
done
