# Examples

this directory contains examples for a few features of the autograder

## Assessments

The Hello folder and Hello.tar contain various examples of different styles of Assessments


## Importing Assessments

whether you are importing one or more assessments the procedure is the same

multiple assessment import starter.tar is the starter file for importing one or more assessments


```bash
multiple assessment import starter.tar
├── assessment1
│   ├── handin
│   ├── assessment1.yml
│   ├── autograde.tar
│   └── autograde-Makefile
└── assessment2
    ├── handin
    └── assessment1.yml

```

the top level must consist of folders named the same as what you will be naming the course (url name not display name) 

assessment1 is an example of an assessment with an autograding component

the handin folder while has to remain present and named the same is not currently used for anything but will be in the future for adding submissions to new assessments.

assessment1.yml
```YAML
---
general:
  name: assessment1
  description: ''
  display_name: ASSESSMENT WITH AUTOGRADING
  handin_filename: handin.zip
  handin_directory: handin
  max_grace_days: 0
  handout: ''
  writeup: ''
  max_submissions: -1
  disable_handins: false
  max_size: 2
  has_svn: false
  category_name: Lab Activities
problems:
- name: Score
  description: ''
  max_score: 3.0
  optional: false
autograder:
  autograde_timeout: 180
  autograde_image: autograding_image
  release_score: true
```
the only hiccup on this file is that the name field must be the same as the file and top level folder name

problems even if there is only 1 must be denoted as a list
~~~
autograde-Makefile, autograde.tar
~~~
will contain your assessment files to ship to tango and be graded with naming is standardized to avoid complications.

assessment2 is an assessment without autograding same rules apply as assessment1 the only difference being the assessment.yml file does not contain the autograder section

```YAML
---
general:
  name: assessment2
  description: ''
  display_name: ASSESSMENT WITH OUT AUOTGRADING
  handin_filename: objects.zip
  handin_directory: handin
  max_grace_days: 0
  handout: ''
  writeup: ''
  max_submissions: -1
  disable_handins: false
  max_size: 5
  has_svn: false
  category_name: RecitationQuiz
problems:
- name: quiz02
  description: ''
  max_score: 100.0
  optional: false
```
