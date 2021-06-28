use v6;

role DSL::English::DataAcquisitionWorkflows::Grammar::RandomDataGeneration {

    # General random data generation command
    rule random-data-generation-command { <random-tabular-data-generation-command>  }

    # Random tabular data generation command
    rule random-tabular-data-generation-command {
        :my Int $*NROWS = 0;
        :my Int $*NCOLS = 0;
        :my Int $*COLNAMES = 0;
        :my Int $*COLGENERATORS = 0;
        :my Int $*MINMISSING = 0;
        :my Int $*MAXMISSING = 0;
        :my Int $*DATASETFORM = 0;
        <.generate-directive>? <.a-determiner>? <.random-adjective> <.tabular-adjective>? <.dataset-phrase> <.filler-separator> <random-tabular-dataset-arguments-list>?
    }

    regex random-tabular-dataset-arguments-list {
        <random-tabular-dataset-argument>+ % [[<list-separator> | <ws>] <filler-separator>?]
    }

    regex random-tabular-dataset-argument {
        <random-tabular-dataset-nrows-spec> |
        <random-tabular-dataset-ncols-spec> |
        <random-tabular-dataset-colnames-spec> |
        <random-tabular-dataset-form-spec> |
        <random-tabular-dataset-col-generators-spec>
    }

    rule filler-separator {
        <and-conjunction>? [ <with-preposition> | <using-preposition> | <for-preposition> ]
    }

    rule random-tabular-dataset-nrows-spec {
        <?{ $*NROWS == 0 }> <integer-value> [ <.number-of-rows-phrase> | <.rows> ] { $*NROWS = 1 }
    }

    rule random-tabular-dataset-ncols-spec {
        <?{ $*NCOLS == 0 }> <integer-value> [ <.number-of-columns-phrase> | <.columns-noun> ] { $*NCOLS = 1 }
    }

    rule random-tabular-dataset-colnames-spec {
        <?{ $*COLNAMES == 0 }> <.the-determiner>? <.column-names-phrase> <column-specs-list> { $*COLNAMES = 1 }
    }

    rule random-tabular-dataset-form-spec {
        <?{ $*DATASETFORM == 0 }> [
          <.in-preposition> <word-value> [ <.form-data-acqui-word> | <.format-data-acqui-word> ] |
          <.the-determiner>? [ <.form-data-acqui-word> | <.format-data-acqui-word> ] <word-value>
        ] { $*DATASETFORM = 1 }
    }

    rule random-tabular-dataset-col-generators-spec {
        <?{ $*COLGENERATORS == 0 }> <.the-determiner>? <.column-generators-phrase> <assign-pairs-list> { $*COLGENERATORS = 1 }
    }

    # Column specs
    rule column-specs-list { <column-spec>+ % <list-separator> }
    rule column-spec { <column-name-spec> | <wl-expr> }
    rule column-name-spec { <mixed-quoted-variable-name> }

    # Phrases
    rule number-of-rows-phrase { <number-noun> <of-preposition> <rows> | <rows> <count-verb> | 'nrows' }
    rule number-of-columns-phrase { <number-noun> <of-preposition> <columns> | <columns> <count-verb> | 'ncols' }
    rule column-names-phrase { [ <column-noun> | <variable-noun> ] <names-noun> }
    rule column-generators-phrase { [ <column-noun> | <variable-noun> ]? [ <generators-data-acqui-word> | <generator-data-acqui-word> ] }
}
