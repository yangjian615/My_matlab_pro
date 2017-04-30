%% These examples show how to use Python? language functions and modules within MATLAB?.
% The first example calls a text-formatting module from the Python standard library.
% The second example shows how to use a third-party module, Beautiful Soup.
% If you want to run that example, follow the guidelines in the step for installing the module.


%% Call a Python Function to Wrap Text in a Paragraph

% MATLAB has equivalencies for much of the Python standard library, but not everything.
% For example, textwrap is a module for formatting blocks of text with carriage returns and other conveniences.
% MATLAB also provides a textwrap function, but it only wraps text to fit inside a UI control.

T = 'MATLAB(R) is a high-level language and interactive environment for numerical computation, visualization, and programming. Using MATLAB, you can analyze data, develop algorithms, and create models and applications. The language, tools, and built-in math functions enable you to explore multiple approaches and reach a solution faster than with spreadsheets or traditional programming languages, such as C/C++ or Java(TM).';
%% Convert a Python String to a MATLAB String
wrapped = py.textwrap.wrap(T);
whos wrapped

%Convert py.list to a cell array of Python strings.

wrapped = cell(wrapped);
whos wrapped

wrapped{1}

%Convert the Python strings to MATLAB strings using the char function.

wrapped = cellfun(@char, wrapped, 'UniformOutput', false);
wrapped{1}

% Customize the Paragraph
tw = py.textwrap.TextWrapper(pyargs(...
    'initial_indent', '% ', ...
    'subsequent_indent', '% ', ...
    'width', int32(30)));
wrapped = wrap(tw,T);

%Convert to a MATLAB argument and display the results.
wrapped = cellfun(@char, cell(wrapped), 'UniformOutput', false);
fprintf('%s\n', wrapped{:})


%% Use Beautiful Soup, a Third-Party Python Module

html = webread('http://en.wikipedia.org/wiki/List_of_countries_by_population');
soup = py.bs4.BeautifulSoup(html,'html.parser');


tables = soup.find_all('table');
t = cell(tables);

c = cell(t{1}.find_all('tr'));
c = cell(c)';

% Now loop over the cell array, extracting the country name and population from each row,
%found in the second and third columns respectively.

countries = cell(size(c));
populations = nan(size(c));

for i = 1:numel(c)
    row = c{i};
    row = cell(row.find_all('td'));
    if ~isempty(row)
        %         countries{i} = char(row{2}.get_text());
        %         populations(i) = str2double(char(row{3}.get_text()));
        countries{i} = char(row{1}.get_text());
        populations(i) = str2double(char(row{2}.get_text()));
    end
end

%
% Finally, create a MATLAB table from the data, and eliminate any lingering nan values;
% these NaNs represented invalid rows when importing the HTML.

data = table(countries, populations, ...
    'VariableNames', {'Country', 'Population'});
data = data(~isnan(data.Population), :);

%Trim the tail end of the table and make a pie chart

restofWorldPopulation = sum(data.Population(11:end));
data = data(1:10, :);
data = [data;table({' Rest of World'}, restofWorldPopulation, ...
    'VariableNames', {'Country', 'Population'})]
pie(data.Population)
legend(data.Country, 'Location', 'EastOutside');
title('Distribution of World Population')

















