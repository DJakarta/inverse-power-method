%% Inverse power method MATLAB visualisation
% Copyright (C) 2017 Cristescu I. Bogdan Ion
% djbogdy3x@yahoo.com
% GNU Affero General Public License
% see https://github.com/DJakarta/inverse-power-method

%% Versioning
% V 1.0.1
% Modified 11.01.2017 02:20

%% GUI read for inverse power method
%	The function displays a GUI asking for a matrix dimension.
%	The instruction text and field regexp for number checking can be
% customized using the GUI parameters.

%% To do
% - instruction text size computed from all possible error texts
% - add support for text and regexp cutomization via arguments

function n = readMatrixSize()
	%% constants
	endl = char(10);
	
	%% GUI parameters
	intRegexp = '^\d+$';
	fieldInst = 'Introduceti dimensiunea matricei:';
	fieldErrInst = ['Valoarea introdusa trebuie sa fie un numar ' ...
					'intreg pozitiv!'];
	displayInst = [endl, 'In cazul unei matrice de '  ...
					'dimensiune 3x3 se va face suplimentar afisarea ' ...
					'vectorului in grafic tridimensional.'];
	
	%% default values
	n = 3;
	
	%% figure
	sFigure = figure(1);
	sFigure.MenuBar = 'none';
	sFigure.ToolBar = 'none';
	sFigure.Resize = 'off';
	rowSpacing = 5;
	columnSpacing = 5;
	
	%% size text
	sText = uicontrol(sFigure);
	sText.Style = 'text';
	sText.String = fieldInst;
	sText.Position(3:4) = sText.Extent(3:4);
	row1Width = sText.Position(3);
	row1Height = sText.Position(4) + rowSpacing;
	
	%% size field
	sField = uicontrol(sFigure);
	sField.Style = 'edit';
	sField.String = n;
	% mark as updated in the other field
	sField.UserData = 1;
	sField.Position(3:4) = sField.Extent(3:4);
	sField.Position(3) = 4*sField.Position(4);
	
	%% 'x' sign
	xSign = uicontrol(sFigure);
	xSign.Style = 'text';
	xSign.String = 'x';
	xSign.Position(3:4) = xSign.Extent(3:4) + [columnSpacing, 0];
	
	%% field repeat for second dimension
	sFieldRepeat = uicontrol(sFigure);
	sFieldRepeat.Style = 'edit';
	sFieldRepeat.Enable = 'off';
	sFieldRepeat.String = sField.String;
	sFieldRepeat.Position(3:4) = sField.Position(3:4);
	
	%% row 2
	row2Height = max([sField.Position(4), xSign.Position(4), ...
					sFieldRepeat.Position(4)]) + rowSpacing;
	row2Width = sField.Position(3) + xSign.Position(3) ...
				+ sFieldRepeat.Position(3);
	
	%% figure width from the first two rows
	figureWidth = max(row1Width, row2Width);
	sFigure.Position(3) = figureWidth;
	
	%% instruction text
	instText = uicontrol(sFigure);
	instText.Style = 'text';
	instText.String = displayInst;
	row3Width = figureWidth;
	instText.Position(3) = row3Width;
	instText.Position(4) = 3 * instText.Extent(4);
	row3Height = instText.Position(4) + rowSpacing;
	
	%% ok button
	okButton = uicontrol(sFigure);
	okButton.Style = 'pushButton';
	okButton.String = 'Ok';
	okButton.Position(3:4) = okButton.Extent(3:4);
	row4Height = okButton.Position(4);
	row4Width = figureWidth;
	okButton.Position(3) = row4Width;
	
	%% positions
	figureHeight = row1Height + row2Height + row3Height + row4Height;
	sFigure.Position(4) = figureHeight;
	sText.Position(1:2) = [0, figureHeight - sText.Position(4)];
	sField.Position(1:2) = [row2Width / 2 - xSign.Position(3) / 2 ...
							- sField.Position(3), figureHeight ...
							- row1Height - sField.Position(4)];
	xSign.Position(1:2) = [row2Width / 2 - xSign.Position(3) / 2, ...
							figureHeight - row1Height - xSign.Position(4)];
	sFieldRepeat.Position(1:2) = [row2Width / 2 ...
									+ xSign.Position(3) / 2, ...
									figureHeight - row1Height ...
									- sFieldRepeat.Position(4)];
	instText.Position(1:2) = [0, figureHeight - row1Height - row2Height ...
								- instText.Position(4)];
	okButton.Position(1:2) = [0, 0];
	
	%% callback
	% ok button callback function
	function okCallback(hObj, cbData, fig, field1, field1Regexp, ...
			instText, field1ErrorInst)
		if isempty(regexp(field1.String, field1Regexp))
			instText.String = field1ErrorInst;
		else
			set(fig, 'UserData', 1);
		end
	end
	
	% set the ok button callback function
	okButton.Callback = {@okCallback, sFigure, sField, intRegexp, ... 
						instText, [fieldErrInst, displayInst]};
	
	% field typing callback function
	function fieldCallback(hObj, cbData, field1, field1Repeat)
		if strcmp(cbData.Key, 'backspace')
			field1Repeat.String = field1Repeat.String(1 : end - 1);
		elseif ~isempty(regexp(cbData.Key, 'arrow'))
			uicontrol(field1Repeat);
			field1Repeat.String = field1.String;
			uicontrol(field1);
		else
			field1Repeat.String = [field1Repeat.String, cbData.Character];
		end
	end
	
	% set the field typing callback function
	sField.KeyReleaseFcn = {@fieldCallback, sField, sFieldRepeat};
	
	% field focus lost callback
	function fieldFocusLost(hObj, cbData, field1, field1Repeat)
		field1Repeat.String = field1.String;
	end

	% set the field focus lost callback
	sField.Callback = {@fieldFocusLost, sField, sFieldRepeat};
	
	%% halt function untill ok is pressed and conditions are met
	% wait until the position is set to zero by the callback from the button
	waitfor(sFigure, 'UserData', 1);
	
	%% field value reading
	n = sscanf(sField.String, '%d');
	
	%% close the figure
	close(sFigure);
end