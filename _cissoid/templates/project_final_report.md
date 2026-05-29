Hi {{full_name}} ({{github_id}}), 

Please see below for your final individual report grade and instructor feedback. 

You uploaded your final individual report at <{{report_url}}>. 
This is the version the instructor used to grade your report. 

Your report had (approximately) {{word_count}} words. 

You received an overall grade of {{overall_grade}} out of {{max_overall_grade}}. 

For more details of how this component was graded, please see the project instructions at 
<https://michael-weylandt.com/STA9750/project.html#final-individual-report>.

Thank you for your participation in STA 9750! I hope it has been, at very least, a rewarding semester for you. 

---

{% for k, v in scores.items() %}
- {{k[0]}} - {{k[1]}}: {{v["score"]}} of {{v["max_score"]}}. (Range '{{v["category_message"]}}'{%if v["comment"]%} with an instructor comment of '{{v["comment"]}}'.}{% endif %})
{% endfor %}
{% if other_penalty %}
Additionally, an adjustment of {{other_penalty}} was applied because: 
{{other_reason}}.
{% endif %}
