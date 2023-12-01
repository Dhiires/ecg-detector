%% Calculate HRV metrics table error

%% Function 
% Computes the absolute error for an array with the first value as the 
% theoric value. Returns the absolute error in an array of the same length
% with the first value always 0.

function err = GetError(vals)
    err = (vals - vals(1));%.*100/vals(1);
    err = abs(err);
end