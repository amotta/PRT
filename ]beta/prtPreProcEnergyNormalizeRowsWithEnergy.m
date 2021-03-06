classdef prtPreProcEnergyNormalizeRowsWithEnergy < prtPreProc
    % prtPreProcEnergyNormalizeRows Normalize the rows of the data to have unit
    % energy
    %

% Copyright (c) 2014 CoVar Applied Technologies
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.





    properties (SetAccess=private)
        
        name = 'Energy Normalize Rows With Energy'  %  MinMax Rows
        nameAbbreviation = 'ENRWE'  % MMR
    end
    
    properties
        %no properties
        energyOffset = 0;
    end
    
    methods
        
        function self = prtPreProcEnergyNormalizeRowsWithEnergy(varargin)
            self = prtUtilAssignStringValuePairs(self,varargin{:});
        end
    end
    
    methods (Access = protected, Hidden = true)
        
        function self = trainAction(self,DataSet) %#ok<INUSD>
            %do nothing
        end
        
        function DataSet = runAction(self,DataSet) %#ok<MANU>
            
            theData = DataSet.getObservations;
            dataEnergy = sqrt(sum(theData.^2,2));
            theData = bsxfun(@rdivide,theData,self.energyOffset + dataEnergy);
            theData = cat(2,dataEnergy,theData);
            DataSet = DataSet.setObservations(theData);
        end
        
        function xOut = runActionFast(self,xIn,ds) %#ok<INUSD>
            
            dataEnergy = sqrt(sum(xIn.^2,2));
            xOut = bsxfun(@rdivide,xIn,self.energyOffset + dataEnergy);
            xOut = cat(2,dataEnergy,xOut);
        end
    end
    
    
    methods (Hidden)
        function str = exportSimpleText(self)
            titleText = sprintf('%% prtPreProcEnergyNormalizeRows\n');
            energyOffsetText = prtUtilMatrixToText(full(self.energyOffset),'varName','energyOffset');
            str = sprintf('%s%s',titleText,energyOffsetText); % No parameters 
        end
    end
    
end
