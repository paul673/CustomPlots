  
  
  function calc_percentage_x_offset(x::Real, base_value::Real, offset::Real)

    if x < base_value
        return x + 3*offset < base_value ? x + offset : base_value
    elseif x > base_value
        return x - 3*offset > base_value ? x - offset : base_value
    else
        return base_value
    end
  end

 function tornado_annotations(x_values::Array,base_value::Real , offset_frac::Real)
    map(x->calc_percentage_x_offset(x, base_value, offset_frac), x_values)
 end

 function get_longest_bar(base_value::Real, positive_output::Array, negative_output::Array)
    return maximum([maximum(abs.(positive_output .- base_value)),maximum(abs.(negative_output .- base_value))])
 end

 function reformate_text(lst::Array, font_size::Int64, color::Symbol, base_value::Real, x_pos::Array)
    labels = map(x ->  text(string(x), color, :center, font_size), lst)
    return map((l,x) -> x==base_value ?  text("", color, :center, font_size) : l ,labels,x_pos)
 end