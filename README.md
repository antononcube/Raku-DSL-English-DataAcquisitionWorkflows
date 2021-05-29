# Raku-DSL-English-DataAcquisitionWorkflows

## In brief

This Raku Perl 6 package has grammar classes and action classes for the parsing and
interpretation of natural language commands that specify Data Acquisition (DA) workflows.

It is envisioned that the interpreters (actions) are going to target different
programming languages: R, Mathematica, Python, etc.

This mind-maps shows the conversational agent components this grammar addresses:

![MindMap](./org/Data-acquisition-workflows-mind-map.png)

This 
[org-mode file](./org/DataAcquisitionWorkflows.org) 
is used to track project's progress.

------

## Installation

```shell
zef install https://github.com/antononcube/Raku-DSL-Shared.git
zef install https://github.com/antononcube/Raku-DSL-Entity-English-Metadata.git
zef install https://github.com/antononcube/Raku-DSL-English-DataAcquisitionWorkflows.git
```

------

# Examples

General recommendation request:

```perl6
use DSL::English::DataAcquisitionWorkflows;

say ToDataAcquisitionWorkflowCode(
    "what data can I get for time series investigations?;
     why did you recommend those",
    "WL-System");
``` 

Recommendation request with subsequent filtering:

```perl6
say ToDataAcquisitionWorkflowCode(
    "I want to investigate data that cross references good purchases with customer demographics
     keep only datasets that can be transformed to star schema",
    "WL-System");
``` 

Data quality verification specification:

```perl6
say ToDataAcquisitionWorkflowCode(
    "verify the quality of the database dbGJ99;
     what fraction of records have missing data;
     what are the distributions of the numerical columns",
    "WL-System");
``` 

Here is a more complicated, statistics pipeline specification:

```perl6
say ToDataAcquisitionWorkflowCode(
    "how many people used customer service data last month;
     what is the breakdown of data sources over data types;
     where textual data is utilized the most;
     plot the results;", "R-tidyverse")
```

Here is a recommendation specification (by collaborative filtering):

```perl6
say ToDataAcquisitionWorkflowCode(
    "what data people like me acquired last month;
     which of those I can use for classfier investigations;
     show me the data sizes and metadata;", "WL-System")
```

------

## References

[AAr1] Anton Antonov,
[DSL::Shared Raku package](https://github.com/antononcube/Raku-DSL-Shared),
(2020),
[GitHub/antononcube](https://github.com/antononcube).

[AAr2] Anton Antonov,
[DSL::Entity::Metadata Raku package](https://github.com/antononcube/Raku-DSL-Entity-Metadata),
(2021),
[GitHub/antononcube](https://github.com/antononcube).
