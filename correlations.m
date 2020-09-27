function SC = correlations(data, markers, maxshift, pattern)  
%   SC = correlations(data, markers, maxshift, pattern)
%   
%   ShiftedCorrelations is a M x N matrix, M being the vertical dimension,
%   where M is length(markers), and N = 2 * maxshift + 1 .
%   
%   Expected arguments :
%     - data: a (vertical) vector of data samples
%       // for a single vector, data(:) will do
%     - markers: a (row) vector of marker indexes in the data array
%       // likewise, for a single vector, markers(:)' would always be horizontal
%     - maxshift: max offset from a marker when computing an offset correlation
%       // yes we do not use xcorr() yet
%     - pattern : a (vertical) vector to correlate around each marker.
%     
%   Result: every column of SC represent shifted correlations 
%           of the pattern around each marker, -maxshift .. maxshift ;
%           the same, the first row of SC are shifted correlations,
%           -maxshift .. maxshift, around marker 1,
%           the second row represents shifted correlations with the pattern
%           near marker 2, and so on
%           
%   Finally, undefined correlations (NaNs) are replaced with zeroes.
%
%   URL: https://github.com/george-fedorov/erp-correlations
%


  % various sanity checks are omitted here -- e.g. maxshift >= 0,
  % the pattern vector shall have some elements ( and ideally at least two ), and so on
  
  % TODO/cosmetic: sz = size(data); data = data(:), then reshape the result in the end
  
  P = length(pattern) ; 
  % we shall slice the data from -radius to + radius :
  radius = maxshift + ceil(P/2); % ... + floor(P/2) + 1

  M = length(markers);
  
  % relative slice indexes
  I = -radius:radius; % length(I) == 2 * radius + 1
  LI = length(I) ; 
  % make it a vertical vector
  I = I'; % or, better: I = I(:);
  
  % convert data into an (LI, M) array of marker-centered data slices :
  
  % (a) replicate relative indexes
  islices = I(:, ones(1,M));
  % (b) replicate marker indices and add them
  islices = islices + markers(ones(1,LI), :);
  % so every column of islices is now is a vector of data indices,
  % shifted around a given marker
  
  % Ok, let's apply the indexes to our data to extract the slices
  slices = data(islices);
  
  % pre-allocate a result matrix
  result = NaN(M, 2 * maxshift + 1);

  % back to our pattern -- let us position it within the 'I' array:
  %    I's are -radius .. radius 
  %    p's are    -p/2 .. p/2    , where 2*(p/2)+1 = P ;
  % so if P is odd, then (P-1)/2 is an integer,
  % and [ -p/2 + radius + 1,  p/2 + radius + 1 ] is our interval ;
  % if P is even, though, it could be e.g. 
  %        -P/2 .. P/2-1 , shifted by the same,
  % or -(P/2)+1 .. (P/2)  ;
  % in other words, (1:L) - ceil(L/2) would do in both cases.
  
  ipattern = (1:P) - ceil(P/2) ;
  
  shift = radius + 1;
  
  % this bit shall probably be replaced with xcorr()
  for i = -maxshift:maxshift
    result(:,i + maxshift + 1) = corr( slices(ipattern+shift+i, :), pattern);
  end;
  
  SC = result;
  
  % fix undefined :
  SC(isnan(SC)) = 0.0 ;



