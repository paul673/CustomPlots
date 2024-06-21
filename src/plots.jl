

"""
    tornado(
        base_value::Float64, 
        positive_output::Array, 
        negative_output::Array, 
        variable_names::Array, 
        config::Dict
        )
Function to plot a tornado chart for sensitivity analysis. 
Takes in the base case output value,
an array containing the outputvalues for an increase in different input variables,
an array containing the outputvalues for an decrease in different input variables,
an array containing the names of the changes variables,
and a dictiononary containing different plot configuration parameters.
The default configuration is given by:

Dict(
    "title" => "",
    "offset_frac" => 0.1,
    "font_size" => 8,
    "font_color" => :black
)
"""
 function  tornado(base_value::Float64, positive_output::Array, negative_output::Array, variable_names::Array, config::Dict)
    
    # Get the amount of variables (must be equal to the length of the variable names array)
    datapoints = maximum([length(positive_output),length(negative_output)]) + 1

    # Extract config data 
    title = get(config, "title", "")
    offset_frac = get(config, "offset_frac", 0.1)
    font_size = get(config, "font_size", 8)
    font_color = get(config, "font_color", :black)


    # get the length of the longest bar to calculate the optimal label offset
    longest_bar_length = get_longest_bar(base_value, positive_output, negative_output)
    offset = longest_bar_length*offset_frac

    # Initiate plot
    p = plot(
        yticks=(1:datapoints,variable_names), 
        title=title
        )

    # Draw base line
    vline!(
        [base_value], 
        linestyle=:dash, 
        label="Basecase", 
        color=:black
        )


    # Plot output from input decrease
    bar!(negative_output,
        fillto = base_value,
        orientation = :horizontal,
        label="50% input decrease",
        )
    

    # Plot output from input increase
    bar!(positive_output,
        fillto = base_value,
        orientation = :horizontal,
        label="50% input increase",
        )

    
    # Set y limits 
    ylims!((0, datapoints))

    # Add values as annotations
    positive_x_pos = tornado_annotations(positive_output,base_value::Real,offset )
    negative_x_pos =tornado_annotations(negative_output,base_value::Real, offset)
    annotate!(
        positive_x_pos, 
        1:length(positive_output),
        reformate_text(positive_output, font_size, font_color,base_value, positive_x_pos) 
        )
    annotate!(
        negative_x_pos, 
        1:length(negative_output),
        reformate_text(negative_output, font_size, font_color,base_value, negative_x_pos) 
        )
    return p
 end





