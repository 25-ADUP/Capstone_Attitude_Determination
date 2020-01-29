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
        conn,
        db_zip
    end
    properties (Hidden)
        cleanup
    end
    methods ( Access = 'public' )
        function obj = ModelStorage(database_zip)
            % db = ModelStorage(database_zip)
            % 
            % Assumes model zip file is in ./model
            % Example: db = ModelStorage('priors.zip')
            
            try
                rmdir('./working_model', 's');  % Remove working model
            catch E
            end
            
            obj.db_zip = database_zip;
            
            disp('Loading model...');
            
            % Make new dir
            mkdir('working_model');
            mkdir('./working_model/contours'); % Make sure contours dir exists
            
            % Set up working dir, not intended for git
            unzip(sprintf('./model/%s', database_zip), './working_model');
            disp('Set up working model.');
            
            % Connect to database
            obj.conn = sqlite('./working_model/priors.db');
            disp('Connected to database.');
            
            % Enable destructor. matlab, why is this not default? please
            obj.cleanup = onCleanup(@()delete(obj));
        end
        function images = fetch_images(obj, varargin)
            % Fetch images with given angles
            % 
            % images = fetch_images(theta)
            % images = fetch_images(theta, psi)
            % images = fetch_images(theta, psi, phi)
            % 
            % Use empty string to exclude angles:
            % masks = fetch_masks('', psi, phi)
            query = obj.build_query('image', varargin{:});
                
            % Fetch query. Returns Nx1 cell of model filenames,
            % without a folder path. Example: "M0_0_0.png"
            found = fetch(obj.conn, query);
            
            % Map filenames to imread function on transposed cell
            images = cellfun( ...
                @(theta, psi, phi, image_fp) ModelImage(theta, psi, phi, double(imread(sprintf('./working_model/masks/%s', image_fp))) ), ...
                found(:,1), found(:,2), found(:,3), found(:,4), ...
                'UniformOutput', false);
            
        end
        function contours = fetch_contours(obj, varargin)
            % Fetch contours with given angles
            % 
            % contours = fetch_contours(theta)
            % contours = fetch_contours(theta, psi)
            % contours = fetch_contours(theta, psi, phi)
            % 
            % Use empty string to exclude angles:
            % contours = fetch_contours('', psi, phi)
            query = obj.build_query('contour', varargin{:});
            
            % Fetch query. Returns Nx1 cell of model filenames,
            % without a folder path. Example: "M0_0_0.png"
            found = fetch(obj.conn, query);
            
            % Map filenames to imread function on transposed cell
            contours = cellfun( ...
                @(theta, psi, phi, contour_fp) ModelContour(theta, psi, phi, double(imread(sprintf('./working_model/contours/%s', contour_fp))) ), ...
                found(:,1), found(:,2), found(:,3), found(:,4), ...
                'UniformOutput', false);
        end
        function [] = insert_contour(obj, theta, psi, phi, contour_image)
            % insert_contour(theta, psi, phi, contour_image);
            % Updates a single row with the contour and saves image to
            % model
            
            % Build filename
            filename = sprintf('C%d_%d_%d.png', theta, psi, phi);
            
            % Write image to file
            imwrite(contour_image, sprintf('./working_model/contours/%s', filename));
            
            % Update contour with filename
               
            exec(obj.conn, ['update angles ' ...
                            sprintf('set contour=''%s'' ', filename) ...
                            sprintf('where theta=%d and psi=%d and phi=%d', theta, psi, phi)]);
            
            % Save
            % exec(obj.conn, 'commit');
        end
    end
    methods ( Static, Access = 'public')
        function query = build_query(column_name, varargin)
            % query = build_query(column, theta, psi, phi)
            % varargin assumed to hold {theta, psi, phi} or fewer
            
            % Make sure column is passed
            if nargin < 1
                error('Please pass at least one argument.');
            end

            params = {};

            % Add each param if it exists
            
            % Theta
            if ~strcmp(varargin{1}, '')
                params{end+1} = sprintf('theta=%d', varargin{1});
            end

            % Psi
            if length(varargin) > 1 && ~strcmp(varargin{2}, '')
                params{end+1} = sprintf('psi=%d', varargin{2});
            end

            % Phi
            if length(varargin) > 2 && ~strcmp(varargin{3}, '')
                params{end+1} = sprintf('phi=%d', varargin{3});
            end

            % Build query
            if isempty(params)
                query = sprintf('select theta, psi, phi, %s from angles', column_name);
            else
                query = sprintf('select theta, psi, phi, %s from angles where %s', column_name, join(string(params), ' and '));
            end
        end
    end
    methods ( Access = 'private')
        function obj = delete(obj)
            % Class destructor
            
            disp('Saving model...');
            
            % Close database
            close(obj.conn);
            disp('Closed connection.');
            
            % Zip it up all pretty
            zip(sprintf('./model/%s', obj.db_zip), {'masks', 'contours', 'priors.db'}, './working_model');
            disp('Saved as zip.');
            
            try
                rmdir('./working_model', 's');  % Remove working model
            catch E
            end
        end
    end
end