#!/usr/bin/env bash

mkdir _tmp_syllabuspacket
cd _tmp_syllabuspacket
wkhtmltopdf https://michael-weylandt.com/STA9750/syllabus.html   syllabus.pdf
wkhtmltopdf https://michael-weylandt.com/STA9750/resources.html  resources.pdf
wkhtmltopdf https://michael-weylandt.com/STA9750/objectives.html objectives.pdf

pdftk syllabus.pdf resources.pdf objectives.pdf cat output syllabus_packet.pdf
mv syllabus_packet.pdf ..
cd ..
rm -rf _tmp_syllabuspacket

