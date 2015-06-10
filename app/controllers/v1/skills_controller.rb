class V1::SkillsController < V1::BaseController

  def index
    @q = Skill.search(params[:q])
    @skills = @q.result
  end

end