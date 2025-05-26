Hi {{full_name}} ({{github_id}}), 

Please see below for your final individual report
grade and instructor feedback. 

You uploaded your final individual report at 
{{report_url}}
This is the version the instructor used to grade your report. 

Your report had (approximately) {{word_count}} words. 

You received an overall grade of {{overall_grade}}. 

For more details of how this component was graded, 
please see the project instructions at 
https://michael-weylandt.com/STA9750/project.html#final-individual-report. 

Thank you for your participation in STA 9750! I hope it
has been, at very least, a rewarding semester for you. 

---

- Code Quality (20%): {{code_quality}}
{% if code_quality_txt %} - Instructor Comments: {{code_quality_txt}} {% endif %}
- Data Acquisition and Processing (20%): {{data_acquisition}}
{% if data_acquisition_txt %} - Instructor Comments: {{data_acquisition_txt}} {% endif %}
- Data Analysis (30%): {{data_analysis}}
{% if data_analysis_txt %} - Instructor Comments: {{data_analysis_txt}} {% endif %}
- Communication and Presentation of Results (30%): {{communication}}
{% if communication_txt %} - Instructor Comments: {{communication_txt}} {% endif %}
{% if other %} 
Beyond these base categories, the following adjustment has been applied: {%if other > 0%}+{%endif%}{{other}}
- {{other_reason}} {% endif %}

Other instructor comments:
- 

