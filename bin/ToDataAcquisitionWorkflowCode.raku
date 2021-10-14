#!/usr/bin/env perl6
use DSL::English::DataAcquisitionWorkflows;

my %*SUB-MAIN-OPTS =
        :named-anywhere,    # allow named variables at any location
        # other possible future options / custom options
        ;

#| Conversion of (natural) DSL commands for data acquisition to code.
sub MAIN
( Str $command, #= natural language command (DSL commands)
  Str :$target = 'WL-System', #= target language/system/package (defaults to 'WL-System')
  Str :$user = '' #= user identifier (defaults to '')
 )
{
    my $codeRes = ToDataAcquisitionWorkflowCode($command, :$target, userID => $user, format => 'hash');
    my $res = "\{ \"COMMAND\" : \"$command\", \"CODE\" : \"{$codeRes<CODE>}\", \"USERID\" : \"$user\", \"DSL\" : \"DSL::English::DataAcquisitionWorkflows\" \}";
    say $res;
}