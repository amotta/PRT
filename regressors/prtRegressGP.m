classdef prtRegressGP < prtRegress
    % prtRegresGP  GP ? regression object
    %
    %   REGRESS = prtRegressGP returns a prtRegressGP object
    %
    %    REGRESS = prtRegressRVM(PROPERTY1, VALUE1, ...) constructs a
    %    prtRegressGP object REGRESS with properties as specified by
    %    PROPERTY/VALUE pairs.
    % 
    %    A prtRegressGP object inherits all properties from the prtRegress
    %    class. In addition, it has the following properties:
    %
    %   covarianceFunction = @(x1,x2)prtKernelQuadExpCovariance(x1,x2, 1, 4, 0, 0);
    %   noiseVariance = 0.01;
    %   CN ?
    %   weights?
    %
    %   Need reference 
    % 
    %   A prtRegressionGP object inherits the PLOT method from the
    %   prtRegress object, and the TRAIN, RUN, CROSSVALIDATE and KFOLDS
    %   methods from the prtAction object.
    %
    %   Example:
    %   
    %   dataSet = prtDataSinc;           % Load a prtDataRegress
    %   dataSet.plot;                    % Display data
    %   reg = prtRegressGP;             % Create a prtRegressRvm object
    %   reg = reg.train(dataSet);        % Train the prtRegressRvm object
    %   reg.plot();                      % Plot the resulting curve
    %   dataSetOut = reg.run(dataSet);   % Run the regressor on the data
    %   hold on;
    %   plot(dataSet.getX,dataSetOut.getX,'c.') % Plot, overlaying the
    %                                           % fitted points with the 
    %                                           % curve and original data
    % legend('Regression curve','Original Points','Fitted points',0)
    %
    %
    %   See also prtRegress, prtRegressRvm, prtRegressLslr
    
    properties (SetAccess=private)
        % Required by prtAction
        name = 'Maximum a Posteriori'
        nameAbbreviation = 'MAP'
        isSupervised = true;
    end
    
    properties
        % Optional parameters
        
        covarianceFunction = @(x1,x2)prtKernelQuadExpCovariance(x1,x2, 1, 4, 0, 0);
        noiseVariance = 0.01;
        
        % Infered parameters
        
        CN = [];
        weights = [];
        
    end
    
    methods
        % Allow for string, value pairs
        function Obj = prtRegressGP(varargin)
            Obj = prtUtilAssignStringValuePairs(Obj,varargin{:});
        end
        function Obj = set.noiseVariance(Obj,value)
            assert(isscalar(value) && value > 0,'Invalid noiseVariance specified; noise variance must be scalar and greater than 0, but specified value is %s',mat2str(value));
        end
        function Obj = set.covarianceFunction(Obj,value)
            assert(isa(value,'function_handle'),'Invalid covarianceFunction specified; noise variance must be a function_handle, but specified value is a %s',class(value));
        end

    end
    
    methods (Access = protected, Hidden = true)
        
        function Obj = trainAction(Obj,DataSet)
            Obj.CN = feval(Obj.covarianceFunction, DataSet.getObservations(), DataSet.getObservations()) + Obj.noiseVariance*eye(DataSet.nObservations);
            
            Obj.weights = Obj.CN\DataSet.getTargets();
        end
        
        function DataSet = runAction(Obj,DataSet)
            k = feval(Obj.covarianceFunction, Obj.DataSet.getObservations(), DataSet.getObservations());
            c = diag(feval(Obj.covarianceFunction, DataSet.getObservations(), DataSet.getObservations())) + Obj.noiseVariance;
            
            DataSet = prtDataSetRegress(k'*Obj.weights);
            DataSet.ActionData.variance = c - prtUtilCalcDiagXcInvXT(k', Obj.CN);
        end
        
    end
    
end