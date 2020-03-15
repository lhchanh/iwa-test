module ApplicationHelper

  def flash_class(type)
    case type.to_sym
      when :notice then "alert alert-success"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end
end
