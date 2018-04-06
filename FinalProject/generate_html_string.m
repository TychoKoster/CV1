function [ total_html ] = generate_html_string(paths1, paths2, paths3, paths4)
    % Generates the html string of the ranked images
    total_html = "";
    lhs = '<td><img src="';
    rhs = '"/></td>';
    for i=1:size(paths1, 2)
        html_string = "<tr>";
        html_string = html_string + lhs + paths1{:, i} + rhs;
        html_string = html_string + lhs + paths2{:, i} + rhs;
        html_string = html_string + lhs + paths3{:, i} + rhs;
        html_string = html_string + lhs + paths4{:, i} + rhs;
        html_string = html_string + "</tr> \n";
        total_html = total_html + html_string;
    end
end



