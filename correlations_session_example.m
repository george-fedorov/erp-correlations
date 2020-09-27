% create a sample data channel
data = rand(1000, 1);
% test it
plot(data);

% add some signal to that noise
t = linspace(-20 * pi, 20 * pi, 1000);
t = t'
data = data + sin(t);
% test it
plot(data);

% create a sample row of markers
markers = 1:100:950
markers = 50 + markers


% now calculate an average
radius = 20
I = -radius:radius
I = I' ; % want a vertical vector
LI = length(I)

M = length(markers);

% build a matrix of indexes by replication
islices = I(:, ones(1,M));
islices = islices + markers(ones(1,LI),:);

slices = data(islices);

avg = mean(slices');
% show it
plot( avg );

% take a fragment of that big average pattern
ipattern = -6:6
ipattern = ipattern + radius + 1
pattern = avg(ipattern); 

% show both
plot(avg); figure; plot(pattern)

% Ok, let us now build an array of correlations
help correlations
maxshift = 5;
sc = correlations(data(:), markers(:)', maxshift, pattern(:) );

% test it
size(sc)
plot( mean(sc) );

% take max correlations -- consider all shifts for every marker
max(sc')

% find markers where max corr >= 0.9
find(max(sc') >= 0.9)

% same with indexes of best correlation
[ msc imsc ] = max(sc')

% relative shift indexes
simsc = imsc - maxshift - 1 % 'simsc' for Shifted Indices of Max( SC ),
                            % 'SC' standing for 'Shifted Correlations'

% indexes of best correlations
smarkers = markers + simsc ; % 'shifted markers'
bmarkers = smarkers( find( msc >= 0.9 ) ) % 'best markers'

% check that they are good // nb: counting averages is shown above with 'markers' 
%                          //     -- just repeat the same with 'bmarkers' and compare the results
bsc = correlations(data(:), bmarkers(:)', maxshift, pattern(:))
[mtest itest] = max(bsc') % now itest sits exactly in the center

