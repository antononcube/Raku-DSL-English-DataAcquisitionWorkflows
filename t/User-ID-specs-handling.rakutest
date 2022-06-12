use lib './lib';
use lib '.';
use DSL::English::DataAcquisitionWorkflows;
use Test;

##===========================================================
## User ID specs handling
##===========================================================

plan 13;

unlike ToDataAcquisitionWorkflowCode('recommend datasets to analyze'), / .* 'UserID' .* /;

like ToDataAcquisitionWorkflowCode('recommend datasets to analyze', userID => '787-89-jjd'), / .* 'UserID:787-89-jjd' .* /;

like ToDataAcquisitionWorkflowCode('recommend datasets to analyze', userID => '787_89.jjd-88'), / .* 'UserID:787_89.jjd-88' .* /;

ok ToDataAcquisitionWorkflowCode('USER ID 949-444-323; I want to acquire civic structure data'),
        'USER ID 949-444-323; I want to acquire civic structure data';

ok ToDataAcquisitionWorkflowCode('USER ID 787_89.jjd-88; I want to acquire local time series data'),
        'USER ID 787_89.jjd-88; I want to acquire local time series data';

ok ToDataAcquisitionWorkflowCode('USER ID mamaJioe94; recommend datasets to analyze'),
        'USER ID mamaJioe94; recommend datasets to analyze';

like ToDataAcquisitionWorkflowCode('USER ID mamaJioe94; recommend datasets to analyze'), / .* 'UserID:mamaJioe94' .* /;

unlike ToDataAcquisitionWorkflowCode('USER ID NONE; recommend datasets to analyze'), / .* 'UserID' .* /;

unlike ToDataAcquisitionWorkflowCode('USER ID NULL; recommend datasets to analyze'), / .* 'UserID' .* /;

like ToDataAcquisitionWorkflowCode('USER ID marekGram88; recommend datasets to analyze', userID => 'harzaGa22' ), / .* 'UserID:marekGram88' .* /;

unlike ToDataAcquisitionWorkflowCode('USER ID marekGram88; recommend datasets to analyze', userID => 'harzaGa22' ), / .* 'UserID:harzaGa22' .* /;

like ToDataAcquisitionWorkflowCode('USER ID NONE; recommend datasets to analyze', userID => 'harzaGa22' ), / .* 'UserID:harzaGa22' .* /;

like ToDataAcquisitionWorkflowCode('USER ID NULL; recommend datasets to analyze', userID => 'harzaGa22' ), / .* 'UserID:harzaGa22' .* /;

done-testing;
