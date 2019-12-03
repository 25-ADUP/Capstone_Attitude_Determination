% | MIT License
% | 
% | Copyright (c) 2019 Sierra MacLeod
% | 
% | Permission is hereby granted, free of charge, to any person obtaining a copy
% | of this software and associated documentation files (the "Software"), to deal
% | in the Software without restriction, including without limitation the rights
% | to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% | copies of the Software, and to permit persons to whom the Software is
% | furnished to do so, subject to the following conditions:
% | 
% | The above copyright notice and this permission notice shall be included in all
% | copies or substantial portions of the Software.
% | 
% | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% | IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% | FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% | AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% | OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% | SOFTWARE.
% | ==============================================================================
% |
% | Module: ModelStorage
% |
% | Description:
% | Defines a class for interfacing with the zipped database model

classdef ModelStorage
    properties
        conn
    end
    methods
        function obj = ModelStorage(database_zip)
            % db = ModelStorage(database_zip)
            % 
            % Assumes model zip file is in ./model
            % Example: db = ModelStorage('priors.zip')
            try
                rmdir('./working_model', 's');  % clear any past data
            catch E
            end
            % make new dir
            mkdir('working_model');
            
            % set up working dir, not intended for git
            unzip(sprintf('./model/%s', database_zip), './working_model');
            
            obj.conn = sqlite('./working_model/priors.db');
        end
        function masks = fetch_masks(obj, theta, psi, phi)
            % Fetch masks with given angles
            % 
            % masks = fetch_masks(theta)
            % masks = fetch_masks(theta, psi)
            % masks = fetch_masks(theta, psi, phi)
            % 
            % Use empty string to exclude angles:
            % masks = fetch_masks('', psi, phi)
            if ~exist('theta', 'var')
                error('Please pass at least one argument.');
            end

            params = {};

            % Add each param if it exists
            if ~strcmp(theta, '')
                params{end+1} = sprintf('theta=%d', theta);
            end

            if exist('psi', 'var') && ~strcmp(psi, '')
                params{end+1} = sprintf('psi=%d', psi);
            end

            if exist('phi', 'var') && ~strcmp(phi, '')
                params{end+1} = sprintf('phi=%d', phi);
            end

            % Build query
            query = sprintf('select image from angles where %s', join(string(params), ' and '));

            % Fetch query. Returns Nx1 cell of model filenames,
            % without a folder path. Example: "M0_0_0.png"
            found_masks = fetch(obj.conn, query);
            
            % Map filenames to imread function on transposed cell
            masks = cellfun(@(mask_fp) imread(sprintf('./working_model/masks/%s', mask_fp)), found_masks', 'UniformOutput', false);
            
        end
        function delete(obj)
            % Class destructor
            close(obj.conn);
        end
    end
end