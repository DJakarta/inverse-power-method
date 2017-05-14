%% Inverse power method MATLAB visualisation
% Copyright (C) 2017 Cristescu I. Bogdan Ion
% djbogdy3x@yahoo.com
% GNU Affero General Public License
% see https://github.com/DJakarta/inverse-power-method

%% Versioning
% V 1.0.0
% Modified 11.01.2017 02:20

%% GUI read for inverse power method
%	The function displays a GUI asking for a matrix dimension, then for a
% matrix and values for tolerance and maximum number of iterations to be
% used for the inverse power method and returns the matrix and these
% values.

%% To do

function [A, tolerance, maxIterations] = readInputs()
	%% call the read of dimension
	n = readMatrixSize();
	
	%% call the read of the matrix
	[A, tolerance, maxIterations] = readMatrix(n);
end