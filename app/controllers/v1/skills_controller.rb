class V1::SkillsController < V1::BaseController
  before_action :set_country, except: [:index]

  def index
    @q = Skill.search(params[:q])
    @skills = @q.result
  end

end