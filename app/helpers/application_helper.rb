module ApplicationHelper

  def nl2br(c)
    c.to_s.gsub(/\n/, "<br/>").html_safe
  end

  def add_query(options = {})
    specified_url = options.delete(:url) || request.path
    if options.delete(:clear).blank?
      queries = (options.inject(h = {}) {|h,v| h.merge(v[0].to_s => v[1])}).reverse_merge(request.query_parameters)
    else
      queries = (options.inject(h = {}) {|h,v| h.merge(v[0].to_s => v[1])})
    end

    "#{specified_url}?#{(queries.delete_if {|k,v| v.blank?}).to_param}"
  end

  def path_match?(options = {})
    class_name = options.delete(:class_name) || "showing"
    expt_ctrls = (options[:controllers].is_a?(Array) ? options.delete(:controllers) : [options.delete(:controllers)]).compact
    expt_actions = (options[:actions].is_a?(Array) ? options.delete(:actions) : [options.delete(:actions)]).compact
    satisfaction = (options.collect {|k,v| ((v.is_a?(NilClass) && !params.keys.include?(k.to_s)) || params[k.to_sym] == v.to_s)}).all?

    if (expt_ctrls.include?(params[:controller]) || expt_ctrls.blank?) && (expt_actions.blank? || expt_actions.include?(params[:action])) && satisfaction
      class_name
    end
  end

end
