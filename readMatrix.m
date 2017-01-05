%% Inverse power method MATLAB visualisation
% Copyright (C) 2017  Cristescu I. Bogdan Ion
% djbogdy3x@yahoo.com
% see https://github.com/DJakarta/inverse-power-method

%% Versioning
% V 1.0.0
% Modified 05.01.2017 02:15

%% GUI read for inverse power method
%	The function displays a GUI asking for a matrix, a value for tolerance
% and values for tolerance and maximum number of iterations, values which
% can be used with the inverse power method.
%	The instruction text and field regexp for number checking can be
% customized using the GUI parameters.

%% To do
% -	general matrix dimensions
% - instruction text size computed from all possible error texts
% - add support for text and regexp cutomization via arguments

function [A, tolerance, maxIterations] = readMatrix()
	%% constants
	endl = char(10);
	
	%% GUI parameters
	floatRegexp = '^\d*\.?\d+$';
	intRegexp = '^\d+$';
	matrixInst = 'Introduceti matricea:';
	field1Inst = 'Introduceti toleranta:';
	field2Inst = ['Introduceti numarul', endl, 'maxim de iteratii:'];
	figInstDefault = 'Completati campurile cu valori numerice.';
	figInstMatrixErr = 'Completati matricea cu valori numerice!';
	figInstField1Err = 'Completati toleranta cu valoare numerica!';
	figInstField2Err = ['Completati numarul de iteratii ', ...
							'cu valoare numerica intreaga!'];
	
	%% default values
	n = 3;
	A = [   0, 1, 2,
			1, 2, 3,
			3, 4, 5];
	tolerance = 5;
	maxIterations = 25;
	
	%% figure
	mFigure = figure(1);
	rowSpacing = 5;
	
	%% matrix table
	mTable = uitable(mFigure);
	mTable.Data = A;
	mTable.RowName = [];
	mTable.ColumnName = [];
	mTable.ColumnEditable = true;
	mTable.ColumnFormat = repmat({'numeric'}, 1, n);
	mTable.UserData = 0;
	mTable.RowStriping = 'off';

	%table size from row and column computed size
	mTable.Position(3:4) = mTable.Extent(3:4);
	
	%text for matrix
	mText = uicontrol(mFigure);
	mText.Style = 'text';
	mText.String = matrixInst;
	mText.Position(3:4) = mText.Extent(3:4);
	
	%% tolerance
	%text for tolerance at the upper right corner of the matrix
	tText = uicontrol(mFigure);
	tText.Style = 'text';
	tText.String = field1Inst;
	tText.Position(3:4) = tText.Extent(3:4);
	
	%field for tolerance below the text for tolerance
	tField = uicontrol(mFigure);
	tField.Style = 'edit';
	tField.String = sprintf('%f', tolerance);
	tField.Position(3:4) = tText.Extent(3:4);
	
	%% maximum iterations
	%text for maximum iteration number below the field for tolerance
	iText = uicontrol(mFigure);
	iText.Style = 'text';
	iText.String = field2Inst;
	iText.Position(3:4) = iText.Extent(3:4);
	
	%field for maximum iteration number below the text for maximum
	%iteration number
	iField = uicontrol(mFigure);
	iField.Style = 'edit';
	iField.String = sprintf('%d', maxIterations);
	iField.Position(3:4) = tText.Extent(3:4);
	
	%% row 1 sizing
	column1Width = max(mTable.Position(3), mText.Position(3));
	column2Width = max([tText.Position(3), tField.Position(3), ...
					iText.Position(3), iField.Position(3)]);
	column1Height = mTable.Position(4) + mText.Position(4);
	column2Height = tText.Position(4) + tField.Position(4) ...
					+ iText.Position(4) + iField.Position(4);
	row1Width = column1Width + column2Width;
	row1Height = max(column1Height, column2Height);
	
	%% instruction row
	%text for instructions
	instText = uicontrol(mFigure);
	instText.Style = 'text';
	instText.String = figInstDefault;
	
	%text position
	row2Width = row1Width;
	instText.Position(3) = row2Width;
	instTextSpacing = rowSpacing;
	row2Height = instText.Extent(4) + instTextSpacing;
	instText.Position(4) = row2Height - instTextSpacing;
	
	%% ok button
	okButton = uicontrol(mFigure);
	okButton.Style = 'pushButton';
	okButton.String = 'Ok';
	row3Width = row2Width;
	okButtonSpacing = rowSpacing;
	row3Height = okButton.Extent(4) + okButtonSpacing;
	okButton.Position(3:4) = [row3Width, row3Height - okButtonSpacing];
	
	%% figure size from table and elements
	figureWidth = row1Width;
	figureHeight = row1Height + row2Height + row3Height;
	mFigure.Position(3) = figureWidth;
	mFigure.Position(4) = figureHeight;
	
	%% element positions from sizes
	mText.Position(1:2) = [0, figureHeight - mText.Position(4)];
	mTable.Position(1:2) = [0, figureHeight - mText.Position(4) ...
							- mTable.Position(4)];
	tText.Position(1:2) = [column1Width, figureHeight - tText.Position(4)];
	tField.Position(1:2) = [column1Width, figureHeight ...
							- tText.Position(4) - tField.Position(4)];
	iText.Position(1:2) = [column1Width, figureHeight ...
							- tText.Position(4) - tField.Position(4) ...
							- iText.Position(4)];
	iField.Position(1:2) = [column1Width, figureHeight ...
							- tText.Position(4) - tField.Position(4) ...
							- iText.Position(4) - iField.Position(4)];
	instText.Position(1:2) = [0, figureHeight - row1Height - row2Height];
	okButton.Position(1:2) = [0, 0];
	
	%% misc
	mFigure.Resize = 'off';
	
	%% callback
	%callback function
	function okCallback(hObj, cbData, fig, table, field1, field1Regexp, ...
			field2, field2Regexp, iText, matrixErrorInst, ...
			field1ErrorInst, field2ErrorInst)
		if sum(sum(isnan(table.Data)))
			iText.String = matrixErrorInst;
		elseif isempty(regexp(field1.String, field1Regexp))
			iText.String = field1ErrorInst;
		elseif isempty(regexp(field2.String, field2Regexp))
			iText.String = field2ErrorInst;
		else
			%set the user data to 1 so the waitfor ends
			set(fig, 'UserData', 1);
		end
	end
	
	%set the callback function
	okButton.Callback = {@okCallback, mFigure, mTable, tField, ...
						floatRegexp, iField, intRegexp, instText, ...
						figInstMatrixErr, figInstField1Err, ...
						figInstField2Err};
	
	%% halt function untill ok is pressed and conditions are met
	%wait until the position is set to zero by the callback from the button
	waitfor(mFigure, 'UserData', 1);
	
	%% field value reading
	A = mTable.Data;
	tolerance = sscanf(tField.String, '%f');
	maxIterations = sscanf(iField.String, '%d');
	
	%% close the figure
	close(mFigure);
end