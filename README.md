# erp-correlations

These are supplementary materials for the following publication: Fedorov G. O., Levichkina E. V., Lavrova V. D., Pigarev I. N., _"Assessment of a single trial impact in the averaged event related potential"_.

Code referred to in the paper is [correlations.m](correlations.m). In addition, [correlations-session-example.m](correlations-session-example.m) shows an example of using it.

<!--
 * `correlations.m` -- code computing the correlations 
 * `correlations-session-example.m` -- usage example for `correlations.m` ;
 * <s> `average.m` -- sample code to calculate ERP averages </s> &nbsp;&nbsp; <font color="green">думаю, это не нужно</font>
-->

## correlations 

    SC = correlations(data, markers, maxshift, pattern)
    
    ShiftedCorrelations is a M x N matrix, M being the vertical dimension,
    where M is length(markers), and N = 2 * maxshift + 1 .
    
    Expected arguments :
      - data: a (column, vertical) vector of data samples
        // for a single vector, data(:) will do
      - markers: a (row, horizontal) vector of marker indexes in the data array
        // likewise, for a single vector, markers(:)' would always be horizontal
      - maxshift: max offset from a marker when computing an offset correlation
        // a scalar (integer) value
      - pattern : a (vertical) vector to correlate around each marker (e.g. an averaged event-related potential).
        // again, for a single vector, pattern(:) would always be vertical
      
    Result: every column of SC represent shifted correlations 
            of the pattern around each marker, -maxshift .. maxshift ;
            in other words: the first row of SC are shifted correlations, -maxshift .. maxshift, around marker 1,
            the second row represents shifted correlations with the pattern near marker 2, and so on.
            
    Finally, undefined correlations (NaNs) are replaced with zeroes.


A few notes:

 1. It is assumed that the `markers` are specified as indexes in the `data` array.  
    Therefore, if e.g. data samples were recorded with a sampling rate *1000 Hz*,  
    and your first marker happens to be at *0.534* from the start of the recording --  
    -- then its Matlab index in the array would be *534*.  
    Or, in Matlab/Octave notation : `marker_indexes = marker_seconds * sampling_rate ;`
  
  2. `data` is assumed to be continuous (e.g. local field potentials - LFP data,  
     or electroencephalography - EEG data); if you intent to use the script  
     for any point process data (e.g. neuronal spikes), average point process   
     in a sliding window (of any desired length) with step equal to 1.  
     
  3. This function wraps and returns [Pearson's Linear Correlation Coefficients](https://mathworks.com/help/stats/corr.html#mw_1b19e0d5-7906-4577-a0a5-b20311da7faf) aka (centered) [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity); to use "sine similarity" introduced in the paper, one has to convert the output `sc = correlations(data, markers, maxshift, pattern)` as follows: `sc(find(sc < 0)) = 0.0 ; sine = 1 - sc .^ 2` .


## correlations-session-example

One way to run this would be to select the code in this session block-by-block, and then run "evaluate selection" in Matlab/Octave (F9).  

 * We have noticed that `corr()` function in Matlab might be a little more picky about argument dimensions that the one in Octave -- so please be careful.   

This example was verified in both Matlab R2015a and Octave 4.2.2 (using console version, `octave-cli`, to avoid quite annoying bug [49385](https://savannah.gnu.org/bugs/?49385)).  
