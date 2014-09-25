require "redmine_issue_statistics/version"
require 'redmine_issue_statistics/calculate_statistics'
module RedmineIssueStatistics

  # [:pl, :en]
  def self.available_locales
    Dir.glob(File.join(Redmine::Plugin.find(:redmine_issue_statistics).directory, 'config', 'locales', '*.yml')).collect {|f| File.basename(f).split('.').first}.collect(&:to_sym)
  end

  private

  def set_default_params r, period
    @user_default_params =
    {
      set_filter: 1,
      "f" => ["assigned_to_id"],
      "op[assigned_to_id]" => "=",
      "v[assigned_to_id][]" => r.statisticable_id
    }
    @project_user_default_params =
    {
      set_filter: 1,
      "f" => ["project_id", "assigned_to_id"],
      "op[project_id]" => "=",
      "op[assigned_to_id]" => "=",
      "v[project_id][]" => r.statisticable_id,
      "v[assigned_to_id][]" => r.relate_id
    }
    @project_default_params =
    {
      set_filter: 1,
      "f" => ["project_id"],
      "op[project_id]" => "=",
      "v[project_id][]" => r.statisticable_id
    }
  end

  def set_path r, period, specified_params = nil
    set_default_params r, period

    if r.statisticable_type == "User"
      redirect_to issues_path(
        if specified_params != nil
          @user_default_params["f"] +=  specified_params["f"]
          specified_params.merge(@user_default_params)
        else
          @user_default_params
        end
      )
    elsif r.statisticable_type == "Project" && r.relate_type == "User"
      redirect_to issues_path(
        if specified_params != nil
          @project_user_default_params["f"] +=  specified_params["f"]
          specified_params.merge(@project_user_default_params)
        else
          @project_user_default_params
        end
      )
    else
      redirect_to issues_path(
        if specified_params != nil
          @project_default_params["f"] +=  specified_params["f"]
          specified_params.merge(@project_default_params)
        else
          @project_default_params
        end
      )
    end
  end

  def redirect_to_total_logged_path results
    redirect_to issues_path({
                              set_filter: 1,
                              "f[]" => "id",
                              "op[id]" => "=",
                              "v[id]" => results
    })
  end

  def redirect_to_path results
    redirect_to issues_path({
                              set_filter: 1,
                              "f[]" => "id",
                              "op[id]" => "=",
                              "v[id]" => results.collect(&:id)
    })
  end
end
