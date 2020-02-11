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
% | Module: BST
% |
% | Description:
% | Defines a class for a generic BST

classdef BST
    properties
        root
    end
    methods ( Access = 'public' )
        function obj = BST ()
            obj.root = BSTNode();
        end
        function tf = lt(obj1, obj2)
            tf = obj1.data < obj2.data;
        end
    end
    methods ( Static )
        function node = max(A, B)
            if (A > B)
                node = A;
            else
                node = B;
            end
        end
        function node = min(A, B)
            if (A < B)
                node = A;
            else
                node = B;
            end
        end
        function num = height(node)
            if (isempty(node))
                num = 0;
            else
                num = node.height;
            end
            
        end
    end
end