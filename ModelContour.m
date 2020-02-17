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
% | Module: ModelContour
% |
% | Description:
% | Defines a class for image queries

classdef ModelContour
    properties
        theta,
        psi,
        phi,
        contour,
        similars
    end
    methods
        function obj = ModelContour(theta, psi, phi, contour)
            obj.theta = theta;
            obj.psi = psi;
            obj.phi = phi;
            obj.contour = contour;
            obj.similars = [];
        end
        function tf = eq(A, B)
            if (isobject(B))
                tf = (A.theta == B.theta) && (A.psi == B.psi) && (A.phi == B.phi);
            else
                tf = (A.theta == B(1)) && (A.psi == B(2)) && (A.phi == B(3));
            end
        end
        function tf = lt(A, B)
            %A
            %B
            %tf = (A.theta == B.theta) && (A.psi == B.psi) && (A.phi == B.phi);
            %if ~tf
                if (A.theta < B.theta) tf = true;
                elseif (A.theta == B.theta)
                    if (A.psi < B.psi) tf = true;
                    elseif (A.psi == B.psi)
                        if (A.phi < B.phi) tf = true;
                        else tf = false;
                        end
                    else tf = false;
                    end
                else tf = false;
                end
            %end
        end
        function tf = gt(A, B)
            if (A.theta > B.theta) tf = true;
            elseif (A.theta == B.theta)
                if (A.psi > B.psi) tf = true;
                elseif (A.psi == B.psi)
                    if (A.phi > B.phi) tf = true;
                    else tf = false;
                    end
                else tf = false;
                end
            else tf = false;
            end
        end
    end
end