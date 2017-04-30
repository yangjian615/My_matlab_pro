function [answer] = ask(prompt,def_ans)
%Jian.ASK Ask a question.
%
%   answer = Jian.ASK(prompt)
%
%   answer = Jian.ASK(prompt,def_ans) Specified default answer.

if(nargin == 1)
    def_ans = '';
end

a = inputdlg(prompt,'Jian.ask',1,{def_ans});

if(isempty(a))
    answer = '';
else
    answer = a{1};
end