function output = prtPath(varargin)
% prtPath Adds necessary directories for the PRT to your path.

% Copyright (c) 2013 New Folder Consulting
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

if isdeployed
    return
end

addpath(fullfile(prtRoot,'util')); % So we can call prtUtilGenCleanPath (legacy)
addpath(fullfile(prtRoot,'code','util')); % So we can call prtUtilGenCleanPath
origPath = prtUtilGenCleanPath(prtRoot);
addpath(origPath);

addedDirs = cat(1,{prtRoot},strsplit(origPath,pathsep)');
addedDirs = addedDirs(~cellfun(@isempty,addedDirs));

for iArg = 1:length(varargin)
    cArg = varargin{iArg};
    anyWasFound = false;
    for iDir = 1:length(addedDirs)
        cDir = fullfile(addedDirs{iDir},cat(2,']',cArg));
        wasFound = logical(exist(cDir,'file'));
        anyWasFound = anyWasFound || wasFound;
        if wasFound
            P = prtUtilGenCleanPath(cDir,'removeDirStart',{'.'});
            addpath(P);
            origPath = cat(2,origPath,P);
            addedDirs = cat(1,{prtRoot},strsplit(origPath,pathsep)');
            addedDirs = addedDirs(~cellfun(@isempty,addedDirs));
        end
    end
    assert(anyWasFound,']%s is not a sub-directory found in %s',cArg,prtRoot);
end
if nargout > 0
    output = origPath;
end
