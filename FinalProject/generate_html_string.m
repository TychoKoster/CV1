function [ html_string ] = generate_html_string(paths)
    html_string = "";
    lhs = "<tr><td><img src=";
    rhs = "/>";
    for path=paths
        html_string = html_string + lhs + path{1} + rhs;
    end
end

