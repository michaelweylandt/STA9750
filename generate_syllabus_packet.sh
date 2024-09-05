#!/usr/bin/env bash
COURSE=STA9750

mkdir _tmp_syllabuspacket
cd _tmp_syllabuspacket
wkhtmltopdf https://michael-weylandt.com/$COURSE/syllabus.html   syllabus.pdf
wkhtmltopdf https://michael-weylandt.com/$COURSE/resources.html  resources.pdf
wkhtmltopdf https://michael-weylandt.com/$COURSE/objectives.html objectives.pdf

pdftk syllabus.pdf resources.pdf objectives.pdf cat output "$COURSE"_syllabus_packet.pdf
mv "$COURSE"_syllabus_packet.pdf ..
cd ..
rm -rf _tmp_syllabuspacket

