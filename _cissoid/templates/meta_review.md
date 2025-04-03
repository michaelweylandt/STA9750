Hi {{ name }} ({{ github }}),
{%- if feedback %}

Thank you for providing peer feedback on MP#0{{ project_id }}
(https://michael-weylandt.com/STA9750/miniprojects/mini0{{ project_id }}.html). 
Your _meta-review_ grade reflects the quality of the feedback you provided to
your peers. Learning to read and understand code written by others is an 
important learning objective of this course: most of the code you interact with
in professional settings will be written by someone else (or by yourself far enough
in the past that it may as well have been written by someone else) and you will
need to read, make sense of, and identify errors in it. The rubric used to 
provide the meta-review grade can be found at 
https://michael-weylandt.com/STA9750/miniprojects.html. 

You were given the following feedback assignments: 

{% for submittor, meta in feedback.items() %}
- Feedback for {{submittor}} at {{meta['url']}}. For this feedback
  you received a score of {{meta['score']}} of 10, with an instructor
  comment of: "{{meta['comment'] | trim }}"
{%- endfor %}

Taken together, these give an overall meta-review score of **{{overall}}**.

Thank you again for your contributions to your peer's educational goals
and to the overall functioning of STA 9750!

{% else %}

I was unable to locate any peer feedback for you during this cycle. 
As such, you have received an overall score of 0 for this portion of the
grade. 

{% endif %}

**This is an automated message. Please contact the course staff with any questions.**
